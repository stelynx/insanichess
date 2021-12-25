import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<_GameEvent, GameState> {
  GameBloc({required InsanichessSettings settings})
      : _resetZoomStreamController = StreamController<void>.broadcast(),
        super(GameState.initial(
          game: InsanichessGame(
            id: 'id',
            whitePlayer: const InsanichessPlayer.testWhite(),
            blackPlayer: const InsanichessPlayer.testBlack(),
            timeControl: const InsanichessTimeControl.blitz(),
          ),
          isWhiteBottom: true,
          rotateOnMove: settings.otb.rotateChessboard,
          mirrorTopPieces: settings.otb.mirrorTopPieces,
        )) {
    on<_Move>(_onMove);
    on<_ZoomChanged>(_onZoomChanged);
    on<_ResetZoom>(_onResetZoom);
    on<_Undo>(_onUndo);
    on<_Forward>(_onForward);
    on<_Backward>(_onBackward);
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

  void move(insanichess.Square from, insanichess.Square to) =>
      add(_Move(from, to));
  void zoomChanged(double value) => add(_ZoomChanged(value));
  void resetZoom() => add(const _ResetZoom());
  void undo() => add(const _Undo());
  void forward() => add(const _Forward());
  void backward() => add(const _Backward());
  void newGame() => add(const _StartNewGame());

  bool canUndo() => state.game.canUndo;
  bool canGoBackward() => state.game.canGoBackward;
  bool canGoForward() => state.game.canGoForward;

  // Handlers

  FutureOr<void> _onMove(_Move event, Emitter<GameState> emit) async {
    state.game.move(insanichess.Move(
      event.from,
      event.to,
      event.promotionTo,
    ));
    emit(state.copyWith(
      isWhiteBottom:
          state.rotateOnMove ? !state.isWhiteBottom : state.isWhiteBottom,
    ));
  }

  FutureOr<void> _onZoomChanged(
    _ZoomChanged event,
    Emitter<GameState> emit,
  ) async {
    emit(state.copyWith(
      enableZoomButton: event.value > 1.0,
    ));
  }

  FutureOr<void> _onResetZoom(
    _ResetZoom event,
    Emitter<GameState> emit,
  ) async {
    _resetZoomStreamController.add(null);
    emit(state.copyWith(enableZoomButton: false));
  }

  FutureOr<void> _onUndo(_Undo event, Emitter<GameState> emit) async {
    state.game.undo();
    emit(state.copyWith());
  }

  FutureOr<void> _onForward(_Forward event, Emitter<GameState> emit) async {
    state.game.forward();
    emit(state.copyWith());
  }

  FutureOr<void> _onBackward(_Backward event, Emitter<GameState> emit) async {
    state.game.backward();
    emit(state.copyWith());
  }

  FutureOr<void> _onStartNewGame(
    _StartNewGame event,
    Emitter<GameState> emit,
  ) async {
    emit(GameState.initial(
      game: InsanichessGame(
        id: '${state.game.id}1',
        whitePlayer: const InsanichessPlayer.testWhite(),
        blackPlayer: const InsanichessPlayer.testBlack(),
        timeControl: const InsanichessTimeControl.blitz(),
      ),
      isWhiteBottom: true,
      rotateOnMove: state.rotateOnMove,
      mirrorTopPieces: state.mirrorTopPieces,
    ));
  }
}
