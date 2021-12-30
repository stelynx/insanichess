part of 'game_history_bloc.dart';

@immutable
class GameHistoryState {
  final bool isLoading;
  final List<InsanichessGame>? games;

  const GameHistoryState({
    required this.isLoading,
    required this.games,
  });

  const GameHistoryState.initial()
      : isLoading = false,
        games = null;

  GameHistoryState copyWith({
    bool? isLoading,
    List<InsanichessGame>? games,
  }) {
    return GameHistoryState(
      isLoading: isLoading ?? this.isLoading,
      games: games ?? this.games,
    );
  }
}
