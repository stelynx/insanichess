part of 'home_bloc.dart';

@immutable
class HomeState {
  final int? gamesInProgress;
  final int? onlinePlayers;

  const HomeState({
    required this.gamesInProgress,
    required this.onlinePlayers,
  });

  const HomeState.initial()
      : gamesInProgress = null,
        onlinePlayers = null;

  HomeState copyWith({
    int? gamesInProgress,
    int? onlinePlayers,
  }) {
    return HomeState(
      gamesInProgress: gamesInProgress ?? this.gamesInProgress,
      onlinePlayers: onlinePlayers ?? this.onlinePlayers,
    );
  }
}
