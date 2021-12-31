part of 'game_history_bloc.dart';

@immutable
abstract class _GameHistoryEvent {
  const _GameHistoryEvent();
}

class _LoadGames extends _GameHistoryEvent {
  const _LoadGames();
}
