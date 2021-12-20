part of 'game_bloc.dart';

@immutable
class GameState {
  final insanichess.Game game;

  const GameState({
    required this.game,
  });

  const GameState.initial({
    required this.game,
  });

  GameState copyWith({
    insanichess.Game? game,
  }) {
    return GameState(game: game ?? this.game);
  }
}
