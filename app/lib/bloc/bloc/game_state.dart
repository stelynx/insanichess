part of 'game_bloc.dart';

@immutable
class GameState {
  final InsanichessGame game;

  const GameState({
    required this.game,
  });

  const GameState.initial({
    required this.game,
  });

  GameState copyWith({
    InsanichessGame? game,
  }) {
    return GameState(game: game ?? this.game);
  }
}
