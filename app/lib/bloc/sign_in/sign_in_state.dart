part of 'sign_in_bloc.dart';

@immutable
class SignInState {
  final String email;
  final String password;

  final bool isLoading;
  final bool? signInSuccessful;
  final bool? hasPlayerProfile;
  final Failure? failure;

  const SignInState({
    required this.email,
    required this.password,
    required this.isLoading,
    required this.signInSuccessful,
    required this.hasPlayerProfile,
    required this.failure,
  });

  const SignInState.initial()
      : email = '',
        password = '',
        isLoading = false,
        signInSuccessful = null,
        hasPlayerProfile = null,
        failure = null;

  SignInState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? signInSuccessful,
    bool? hasPlayerProfile,
    Failure? failure,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      signInSuccessful: signInSuccessful,
      hasPlayerProfile: hasPlayerProfile,
      failure: failure,
    );
  }
}
