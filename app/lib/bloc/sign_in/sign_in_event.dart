part of 'sign_in_bloc.dart';

@immutable
abstract class _SignInEvent {
  const _SignInEvent();
}

class _EmailChanged extends _SignInEvent {
  final String value;

  const _EmailChanged(this.value);
}

class _PasswordChanged extends _SignInEvent {
  final String value;

  const _PasswordChanged(this.value);
}

class _SubmitSignIn extends _SignInEvent {
  const _SubmitSignIn();
}

class _SubmitRegister extends _SignInEvent {
  const _SubmitRegister();
}
