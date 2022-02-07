import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/backend_service.dart';
import '../../services/wss_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../global/global_bloc.dart';

part 'live_game_event.dart';
part 'live_game_state.dart';

const Duration _kTimerDuration = Duration(milliseconds: 10);

class LiveGameBloc extends Bloc<_LiveGameEvent, LiveGameState> {
  final String liveGameId;

  final GlobalBloc _globalBloc;
  final BackendService _backendService;
  final WssService _wssService;

  StreamSubscription<InsanichessGameEvent>? _gameEventStreamSubscription;

  final StreamController<void> _resetZoomStreamController;
  Stream<void> get resetZoomStream => _resetZoomStreamController.stream;

  Timer? _timer;

  LiveGameBloc({
    required this.liveGameId,
    required GlobalBloc globalBloc,
    required BackendService backendService,
    required WssService wssService,
  })  : _globalBloc = globalBloc,
        _backendService = backendService,
        _wssService = wssService,
        _resetZoomStreamController = StreamController<void>.broadcast(),
        super(LiveGameState.initial(
          showZoomOutButtonOnLeft:
              globalBloc.state.settings!.showZoomOutButtonOnLeft,
          showLegalMoves: globalBloc.state.settings!.showLegalMoves,
          autoPromoteToQueen:
              globalBloc.state.settings!.live.alwaysPromoteToQueen,
          autoZoomOutOnMove: globalBloc.state.settings!.live.autoZoomOutOnMove,
        )) {
    on<_Initialize>(_onInitialize);
    on<_TimerTick>(_onTimerTick);
    on<_GameEventReceived>(_onGameEventReceived);
    on<_Move>(_onMove);
    on<_RequestUndo>(_onRequestUndo);
    on<_CancelUndo>(_onCancelUndo);
    on<_RespondToUndo>(_onRespondToUndo);
    on<_OfferDraw>(_onOfferDraw);
    on<_CancelOfferDraw>(_onCancelOfferDraw);
    on<_RespondToOfferDraw>(_onRespondToOfferDraw);
    on<_Resign>(_onResign);
    on<_ZoomChanged>(_onZoomChanged);
    on<_ResetZoom>(_onResetZoom);
    on<_Forward>(_onForward);
    on<_Backward>(_onBackward);

    add(_Initialize(liveGameId: liveGameId));
  }

  @override
  Future<void> close() async {
    await _gameEventStreamSubscription?.cancel();
    await _resetZoomStreamController.close();
    _timer?.cancel();
    return super.close();
  }

  // Public API

  void move(insanichess.Move move) => add(_Move(move));
  void requestUndo() => add(const _RequestUndo());
  void cancelUndo() => add(const _CancelUndo());
  void respondToUndo(bool accept) => add(_RespondToUndo(accept));
  void offerDraw() => add(const _OfferDraw());
  void cancelOfferDraw() => add(const _CancelOfferDraw());
  void respondToOfferDraw(bool accept) => add(_RespondToOfferDraw(accept));
  void resign() => add(const _Resign());
  void zoomChanged(double value) => add(_ZoomChanged(value));
  void resetZoom() => add(const _ResetZoom());
  void forward() => add(const _Forward());
  void backward() => add(const _Backward());

  bool canUndo() => state.game!.undoAllowed && state.game!.canUndo;
  bool canGoBackward() => state.game!.canGoBackward;
  bool canGoForward() => state.game!.canGoForward;

  // Handlers

  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<LiveGameState> emit,
  ) async {
    Either<BackendFailure, InsanichessLiveGame> liveGameOrFailure =
        await _backendService.getLiveGameDetails(event.liveGameId);

    int retryCounter = 0;
    while (liveGameOrFailure.isError() && retryCounter < 3) {
      await Future.delayed(const Duration(seconds: 2));
      liveGameOrFailure =
          await _backendService.getLiveGameDetails(event.liveGameId);
      retryCounter++;
    }

    if (liveGameOrFailure.isError()) {
      emit(state.copyWith(failedToJoinTheGame: true));
      return;
    }

    final insanichess.PieceColor myColor =
        liveGameOrFailure.value.whitePlayer == _globalBloc.state.playerMyself
            ? insanichess.PieceColor.white
            : insanichess.PieceColor.black;

    Either<BackendFailure, StreamSubscription<InsanichessGameEvent>>
        gameEventStreamSubscriptionOrFailure =
        await _wssService.connectToPlayerSocket(
      gameId: liveGameOrFailure.value.id,
      color: myColor,
      onEventReceived: (InsanichessGameEvent gameEvent) =>
          add(_GameEventReceived(gameEvent)),
    );

    retryCounter = 0;
    while (gameEventStreamSubscriptionOrFailure.isError() && retryCounter < 3) {
      gameEventStreamSubscriptionOrFailure =
          await _wssService.connectToPlayerSocket(
        gameId: liveGameOrFailure.value.id,
        color: myColor,
        onEventReceived: (InsanichessGameEvent gameEvent) =>
            add(_GameEventReceived(gameEvent)),
      );
      retryCounter++;
    }

    if (gameEventStreamSubscriptionOrFailure.isError()) {
      emit(state.copyWith(failedToJoinTheGame: true));
      return;
    }

    _gameEventStreamSubscription = gameEventStreamSubscriptionOrFailure.value;

    emit(state.copyWith(game: liveGameOrFailure.value, myColor: myColor));
    _timer = Timer.periodic(_kTimerDuration, (_) => add(const _TimerTick()));
  }

  FutureOr<void> _onTimerTick(
    _TimerTick event,
    Emitter<LiveGameState> emit,
  ) async {
    emit(state.copyWith(
      currentMoveDuration: state.currentMoveDuration + _kTimerDuration,
    ));
  }

  FutureOr<void> _onGameEventReceived(
    _GameEventReceived event,
    Emitter<LiveGameState> emit,
  ) async {
    switch (event.gameEvent.type) {
      case GameEventType.movePlayed:
        _timer?.cancel();

        final MovePlayedGameEvent movePlayedGameEvent =
            event.gameEvent as MovePlayedGameEvent;

        if (movePlayedGameEvent.player != state.myColor) {
          state.game!.move(movePlayedGameEvent.move);
        }

        // Update time related values.
        state.game!.updateTime(
          movePlayedGameEvent.timeSpent!,
          movePlayedGameEvent.player!,
        );

        // Reset undo and draw requests.
        state.game!.playerOfferedDraw = null;
        state.game!.playerRequestedUndo = null;

        emit(state.copyWith(currentMoveDuration: Duration.zero));
        if (!state.game!.isGameOver) {
          _timer =
              Timer.periodic(_kTimerDuration, (_) => add(const _TimerTick()));
        }
        break;

      case GameEventType.drawOffered:
        state.game!.playerOfferedDraw =
            state.myColor == insanichess.PieceColor.white
                ? insanichess.PieceColor.black
                : insanichess.PieceColor.white;
        emit(state.copyWith());
        break;

      case GameEventType.drawOfferCancelled:
        // This event is never sent by the server so we can do nothing here.
        break;

      case GameEventType.drawOfferResponded:
        // This event is sent from the server and it contains the information
        // whether the opponent accepted the draw offer or not.
        if ((event.gameEvent as DrawOfferRespondedGameEvent).accept) {
          _timer?.cancel();
          state.game!.draw();
        }
        // Do not set `state.game!.playerOfferedDraw = null;` here because if a
        // draw has been offered on this move and declined, we don't want the
        // client to spam this event.
        emit(state.copyWith(drawOfferResponded: true));
        break;

      case GameEventType.undoRequested:
        state.game!.playerRequestedUndo =
            state.myColor == insanichess.PieceColor.white
                ? insanichess.PieceColor.black
                : insanichess.PieceColor.white;
        emit(state.copyWith());
        break;

      case GameEventType.undoCancelled:
        // This event is never sent by the server so we can do nothing here.
        break;

      case GameEventType.undoRequestResponded:
        // This event is sent from the server and it contains the information
        // whether the opponent accepted undo request or not.
        if ((event.gameEvent as UndoRespondedGameEvent).accept) {
          _timer?.cancel();
          state.game!.undo();
          _timer =
              Timer.periodic(_kTimerDuration, (_) => add(const _TimerTick()));
        }
        // Do not call `state.game!.playerRequestedUndo = null;` here because if
        // a undo request has been issued on this move and declined, we don't
        // want the client to spam this event.
        emit(state.copyWith(undoRequestResponded: true));
        break;

      case GameEventType.resigned:
        _timer?.cancel();
        // This event is sent from the server and it notifies the client that
        // opponent resigned.
        if (state.myColor == insanichess.PieceColor.black) {
          state.game!.whiteResigned();
        } else {
          state.game!.blackResigned();
        }
        emit(state.copyWith());
        break;

      case GameEventType.disbanded:
        _timer?.cancel();
        emit(state.copyWith(gameDisbanded: true));
        break;

      case GameEventType.flagged:
        _timer?.cancel();
        state.game!.flagged((event.gameEvent as FlaggedGameEvent).player);
        emit(state.copyWith());
        break;
    }
  }

  FutureOr<void> _onMove(_Move event, Emitter<LiveGameState> emit) async {
    final Either<BackendFailure, void> nullOrFailure = _wssService
        .addEventToPlayerSocket(MovePlayedGameEvent(move: event.move));

    if (nullOrFailure.isError()) return;

    state.game!.move(event.move);
    emit(state.copyWith());
  }

  FutureOr<void> _onRequestUndo(
    _RequestUndo event,
    Emitter<LiveGameState> emit,
  ) async {
    final Either<BackendFailure, void> nullOrFailure =
        _wssService.addEventToPlayerSocket(const UndoRequestedGameEvent());

    if (nullOrFailure.isError()) return;

    state.game!.playerRequestedUndo = state.myColor;
    emit(state.copyWith(undoRequestResponded: false));
  }

  FutureOr<void> _onCancelUndo(
    _CancelUndo event,
    Emitter<LiveGameState> emit,
  ) async {
    final Either<BackendFailure, void> nullOrFailure =
        _wssService.addEventToPlayerSocket(const UndoCancelledGameEvent());

    if (nullOrFailure.isError()) return;

    state.game!.playerRequestedUndo = null;
    emit(state.copyWith());
  }

  FutureOr<void> _onRespondToUndo(
    _RespondToUndo event,
    Emitter<LiveGameState> emit,
  ) async {
    final Either<BackendFailure, void> nullOrFailure = _wssService
        .addEventToPlayerSocket(UndoRespondedGameEvent(accept: event.accept));

    if (nullOrFailure.isError()) return;

    state.game!.playerRequestedUndo = null;
    if (event.accept) {
      _timer?.cancel();
      state.game!.undo();
      _timer = Timer.periodic(_kTimerDuration, (_) => add(const _TimerTick()));
    }

    emit(state.copyWith());
  }

  FutureOr<void> _onOfferDraw(
    _OfferDraw event,
    Emitter<LiveGameState> emit,
  ) async {
    final Either<BackendFailure, void> nullOrFailure =
        _wssService.addEventToPlayerSocket(const DrawOfferedGameEvent());

    if (nullOrFailure.isError()) return;

    state.game!.playerOfferedDraw = state.myColor;

    emit(state.copyWith(drawOfferResponded: false));
  }

  FutureOr<void> _onCancelOfferDraw(
    _CancelOfferDraw event,
    Emitter<LiveGameState> emit,
  ) async {
    final Either<BackendFailure, void> nullOrFailure =
        _wssService.addEventToPlayerSocket(const DrawOfferCancelledGameEvent());

    if (nullOrFailure.isError()) return;

    state.game!.playerOfferedDraw = null;
    emit(state.copyWith());
  }

  FutureOr<void> _onRespondToOfferDraw(
    _RespondToOfferDraw event,
    Emitter<LiveGameState> emit,
  ) async {
    final Either<BackendFailure, void> nullOrFailure =
        _wssService.addEventToPlayerSocket(
            DrawOfferRespondedGameEvent(accept: event.accept));

    if (nullOrFailure.isError()) return;

    state.game!.playerOfferedDraw = null;
    if (event.accept == true) {
      _timer?.cancel();
      state.game!.draw();
    }

    emit(state.copyWith());
  }

  FutureOr<void> _onResign(
    _Resign event,
    Emitter<LiveGameState> emit,
  ) async {
    final Either<BackendFailure, void> nullOrFailure =
        _wssService.addEventToPlayerSocket(const ResignedGameEvent());

    if (nullOrFailure.isError()) return;

    _timer?.cancel();
    if (state.myColor == insanichess.PieceColor.white) {
      state.game!.whiteResigned();
    } else {
      state.game!.blackResigned();
    }

    emit(state.copyWith());
  }

  FutureOr<void> _onZoomChanged(
    _ZoomChanged event,
    Emitter<LiveGameState> emit,
  ) async {
    emit(state.copyWith(
      enableZoomButton: event.value > 1.0,
    ));
  }

  FutureOr<void> _onResetZoom(
    _ResetZoom event,
    Emitter<LiveGameState> emit,
  ) async {
    _resetZoomStreamController.add(null);
    emit(state.copyWith(enableZoomButton: false));
  }

  FutureOr<void> _onForward(_Forward event, Emitter<LiveGameState> emit) async {
    state.game!.forward();
    emit(state.copyWith());
  }

  FutureOr<void> _onBackward(
      _Backward event, Emitter<LiveGameState> emit) async {
    state.game!.backward();
    emit(state.copyWith());
  }
}
