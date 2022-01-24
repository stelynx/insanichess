part of 'join_game_with_id_bloc.dart';

@immutable
abstract class _JoinGameWithIdEvent {
  const _JoinGameWithIdEvent();
}

class _IdChanged extends _JoinGameWithIdEvent {
  final String value;

  const _IdChanged(this.value);
}

class _Join extends _JoinGameWithIdEvent {
  const _Join();
}
