import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<_GameEvent, GameState> {
  GameBloc()
      : super(GameState.initial(
          game: InsanichessGame(
            id: 'id',
            whitePlayer: const InsanichessPlayer.testWhite(),
            blackPlayer: const InsanichessPlayer.testBlack(),
            timeControl: const InsanichessTimeControl.blitz(),
          ),
        )) {
    on<_Move>(_onMove);
    on<_Undo>(_onUndo);
    on<_Forward>(_onForward);
    on<_Backward>(_onBackward);
    on<_StartNewGame>(_onStartNewGame);
  }

  // Public API

  void move(insanichess.Square from, insanichess.Square to) =>
      add(_Move(from, to));
  void undo() => add(const _Undo());
  void forward() => add(const _Forward());
  void backward() => add(const _Backward());
  void newGame() => add(const _StartNewGame());

  bool canUndo() => state.game.movesPlayed.isNotEmpty;
  bool canGoBackward() => state.game.movesPlayed.isNotEmpty;
  bool canGoForward() => state.game.movesFromFuture.isNotEmpty;

  // Handlers

  FutureOr<void> _onMove(_Move event, Emitter<GameState> emit) async {
    state.game.move(insanichess.Move(event.from, event.to, event.promotionTo));
    emit(state.copyWith());
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
    // TODO new game does not work
    emit(GameState.initial(
      game: InsanichessGame(
        id: '${state.game.id}1',
        whitePlayer: const InsanichessPlayer.testWhite(),
        blackPlayer: const InsanichessPlayer.testBlack(),
        timeControl: const InsanichessTimeControl.blitz(),
      ),
    ));
  }
}
