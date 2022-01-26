import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/local_storage_service.dart';

part 'otb_game_event.dart';
part 'otb_game_state.dart';

const Duration _kTimerDuration = Duration(milliseconds: 10);

class OtbGameBloc extends Bloc<_OtbGameEvent, OtbGameState> {
  final LocalStorageService _localStorageService;

  Timer? _timer;

  OtbGameBloc({
    required LocalStorageService localStorageService,
    required InsanichessGame? gameBeingShown,
    required InsanichessTimeControl? timeControl,
    required InsanichessSettings settings,
  })  : assert((gameBeingShown == null && timeControl != null) ||
            (gameBeingShown != null && timeControl == null)),
        _localStorageService = localStorageService,
        _resetZoomStreamController = StreamController<void>.broadcast(),
        super(OtbGameState.initial(
          game: gameBeingShown ??
              InsanichessLiveGame(
                id: '${DateTime.now().millisecondsSinceEpoch}',
                undoAllowed: true,
                whitePlayer: const InsanichessPlayer.testWhite(),
                blackPlayer: const InsanichessPlayer.testBlack(),
                timeControl: timeControl!,
              ),
          isWhiteBottom: true,
          rotateOnMove: settings.otb.rotateChessboard,
          mirrorTopPieces: settings.otb.mirrorTopPieces,
          showZoomOutButtonOnLeft: settings.showZoomOutButtonOnLeft,
          showLegalMoves: settings.showLegalMoves,
          autoPromoteToQueen: settings.otb.alwaysPromoteToQueen,
          allowUndo: settings.otb.allowUndo,
          autoZoomOutOnMove: settings.otb.autoZoomOutOnMove,
        )) {
    on<_Move>(_onMove);
    on<_TimerTick>(_onTimerTick);
    on<_ZoomChanged>(_onZoomChanged);
    on<_ResetZoom>(_onResetZoom);
    on<_Undo>(_onUndo);
    on<_Forward>(_onForward);
    on<_Backward>(_onBackward);
    on<_AgreeToDraw>(_onAgreeToDraw);
    on<_Resign>(_onResign);
    on<_StartNewGame>(_onStartNewGame);
  }

  @override
  Future<void> close() async {
    await _resetZoomStreamController.close();
    _timer?.cancel();
    return super.close();
  }

  final StreamController<void> _resetZoomStreamController;
  Stream<void> get resetZoomStream => _resetZoomStreamController.stream;

  // Public API

  void move(insanichess.Move move) => add(_Move(move));
  void zoomChanged(double value) => add(_ZoomChanged(value));
  void resetZoom() => add(const _ResetZoom());
  void undo() => add(const _Undo());
  void forward() => add(const _Forward());
  void backward() => add(const _Backward());
  void agreeToDraw() => add(const _AgreeToDraw());
  void resign() => add(const _Resign());
  void newGame() => add(const _StartNewGame());

  bool isLiveGame() => state.game is InsanichessLiveGame;
  bool canUndo() => state.game.canUndo;
  bool canGoBackward() => state.game.canGoBackward;
  bool canGoForward() => state.game.canGoForward;

  // Handlers

  FutureOr<void> _onMove(_Move event, Emitter<OtbGameState> emit) async {
    final Duration timeSpentForMove = state.currentMoveDuration;
    final insanichess.PieceColor playerOnTurn = state.game.playerOnTurn;

    final insanichess.PlayedMove? playedMove = state.game.move(event.move);
    if (playedMove == null) return;

    // Start clock after first move.
    if (state.game.timesSpentPerMove.isEmpty) {
      _timer = Timer.periodic(_kTimerDuration, (_) => add(const _TimerTick()));
    }

    (state.game as InsanichessLiveGame).updateTime(
      timeSpentForMove,
      playerOnTurn,
    );

    emit(state.copyWith(
      currentMoveDuration: Duration.zero,
      isWhiteBottom:
          state.rotateOnMove ? !state.isWhiteBottom : state.isWhiteBottom,
    ));
    if (state.autoZoomOutOnMove == AutoZoomOutOnMoveBehaviour.always) {
      _resetZoomStreamController.add(null);
    }
    if (state.game.isGameOver) {
      _timer?.cancel();
      await _localStorageService.saveGame(state.game);
    }
  }

  FutureOr<void> _onTimerTick(
    _TimerTick event,
    Emitter<OtbGameState> emit,
  ) async {
    emit(state.copyWith(
      currentMoveDuration: state.currentMoveDuration + _kTimerDuration,
    ));
    if (state.game.playerOnTurn == insanichess.PieceColor.white) {
      if ((state.game.remainingTimeWhite - state.currentMoveDuration)
              .inMilliseconds ==
          0) {
        _timer?.cancel();
        state.game.flagged(insanichess.PieceColor.white);
        emit(state.copyWith());
      }
    } else {
      if ((state.game.remainingTimeBlack - state.currentMoveDuration)
              .inMilliseconds ==
          0) {
        _timer?.cancel();
        state.game.flagged(insanichess.PieceColor.black);
        emit(state.copyWith());
        await _localStorageService.saveGame(state.game);
      }
    }
  }

  FutureOr<void> _onZoomChanged(
    _ZoomChanged event,
    Emitter<OtbGameState> emit,
  ) async {
    emit(state.copyWith(
      enableZoomButton: event.value > 1.0,
    ));
  }

  FutureOr<void> _onResetZoom(
    _ResetZoom event,
    Emitter<OtbGameState> emit,
  ) async {
    _resetZoomStreamController.add(null);
    emit(state.copyWith(enableZoomButton: false));
  }

  FutureOr<void> _onUndo(_Undo event, Emitter<OtbGameState> emit) async {
    state.game.undo();
    emit(state.copyWith());
  }

  FutureOr<void> _onForward(_Forward event, Emitter<OtbGameState> emit) async {
    state.game.forward();
    emit(state.copyWith());
  }

  FutureOr<void> _onBackward(
      _Backward event, Emitter<OtbGameState> emit) async {
    state.game.backward();
    emit(state.copyWith());
  }

  FutureOr<void> _onAgreeToDraw(
    _AgreeToDraw event,
    Emitter<OtbGameState> emit,
  ) async {
    state.game.draw();
    _timer?.cancel();
    emit(state.copyWith());
    _resetZoomStreamController.add(null);
    await _localStorageService.saveGame(state.game);
  }

  FutureOr<void> _onResign(
    _Resign event,
    Emitter<OtbGameState> emit,
  ) async {
    _timer?.cancel();
    if (state.game.playerOnTurn == insanichess.PieceColor.white) {
      state.game.whiteResigned();
    } else {
      state.game.blackResigned();
    }

    emit(state.copyWith());
    _resetZoomStreamController.add(null);
    await _localStorageService.saveGame(state.game);
  }

  FutureOr<void> _onStartNewGame(
    _StartNewGame event,
    Emitter<OtbGameState> emit,
  ) async {
    emit(OtbGameState.initial(
      game: InsanichessGame(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        whitePlayer: const InsanichessPlayer.testWhite(),
        blackPlayer: const InsanichessPlayer.testBlack(),
        timeControl: const InsanichessTimeControl.blitz(),
      ),
      isWhiteBottom: true,
      rotateOnMove: state.rotateOnMove,
      mirrorTopPieces: state.mirrorTopPieces,
      showZoomOutButtonOnLeft: state.showZoomOutButtonOnLeft,
      showLegalMoves: state.showLegalMoves,
      autoPromoteToQueen: state.autoPromoteToQueen,
      allowUndo: state.allowUndo,
      autoZoomOutOnMove: state.autoZoomOutOnMove,
    ));
    _timer = Timer.periodic(_kTimerDuration, (_) => add(const _TimerTick()));
  }
}
