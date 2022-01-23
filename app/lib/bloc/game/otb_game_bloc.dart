import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/local_storage_service.dart';

part 'otb_game_event.dart';
part 'otb_game_state.dart';

class OtbGameBloc extends Bloc<_OtbGameEvent, OtbGameState> {
  final LocalStorageService _localStorageService;
  final InsanichessGame? _gameBeingShown;

  OtbGameBloc({
    required LocalStorageService localStorageService,
    required InsanichessGame? gameBeingShown,
    required InsanichessSettings settings,
  })  : _localStorageService = localStorageService,
        _gameBeingShown = gameBeingShown,
        _resetZoomStreamController = StreamController<void>.broadcast(),
        super(OtbGameState.initial(
          game: gameBeingShown ??
              InsanichessGame(
                id: '${DateTime.now().millisecondsSinceEpoch}',
                whitePlayer: const InsanichessPlayer.testWhite(),
                blackPlayer: const InsanichessPlayer.testBlack(),
                timeControl: const InsanichessTimeControl.blitz(),
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
    on<_ZoomChanged>(_onZoomChanged);
    on<_ResetZoom>(_onResetZoom);
    on<_Undo>(_onUndo);
    on<_Forward>(_onForward);
    on<_Backward>(_onBackward);
    on<_AgreeToDraw>(_onAgreeToDraw);
    on<_StartNewGame>(_onStartNewGame);
  }

  @override
  Future<void> close() async {
    await _resetZoomStreamController.close();
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
  void newGame() => add(const _StartNewGame());

  bool isLiveGame() => _gameBeingShown == null;
  bool canUndo() => state.game.canUndo;
  bool canGoBackward() => state.game.canGoBackward;
  bool canGoForward() => state.game.canGoForward;

  // Handlers

  FutureOr<void> _onMove(_Move event, Emitter<OtbGameState> emit) async {
    final insanichess.PlayedMove? playedMove = state.game.move(event.move);

    if (playedMove == null) return;

    emit(state.copyWith(
      isWhiteBottom:
          state.rotateOnMove ? !state.isWhiteBottom : state.isWhiteBottom,
    ));
    if (state.autoZoomOutOnMove == AutoZoomOutOnMoveBehaviour.always) {
      _resetZoomStreamController.add(null);
    }
    if (state.game.isGameOver) {
      await _localStorageService.saveGame(state.game);
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
  }
}
