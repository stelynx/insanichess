part of 'player_registration_bloc.dart';

@immutable
class PlayerRegistrationState {
  final String username;

  final bool isLoading;
  final bool? isRegistrationSuccessful;
  final Failure? failure;

  const PlayerRegistrationState({
    required this.username,
    required this.isLoading,
    required this.isRegistrationSuccessful,
    required this.failure,
  });

  const PlayerRegistrationState.initial()
      : username = '',
        isLoading = false,
        isRegistrationSuccessful = null,
        failure = null;

  PlayerRegistrationState copyWith({
    String? username,
    bool? isLoading,
    bool? isRegistrationSuccessful,
    Failure? failure,
  }) {
    return PlayerRegistrationState(
      username: username ?? this.username,
      isLoading: isLoading ?? this.isLoading,
      isRegistrationSuccessful: isRegistrationSuccessful,
      failure: failure,
    );
  }
}
