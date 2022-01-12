part of 'player_registration_bloc.dart';

@immutable
abstract class _PlayerRegistrationEvent {
  const _PlayerRegistrationEvent();
}

class _UsernameChanged extends _PlayerRegistrationEvent {
  final String value;

  const _UsernameChanged(this.value);
}

class _SubmitRegister extends _PlayerRegistrationEvent {
  const _SubmitRegister();
}
