part of 'join_game_with_id_bloc.dart';

@immutable
class JoinGameWithIdState {
  final String gameId;
  final bool isLoading;
  final bool? joiningSuccessful;
  final BackendFailure? backendFailure;

  const JoinGameWithIdState({
    required this.gameId,
    required this.isLoading,
    required this.joiningSuccessful,
    required this.backendFailure,
  });

  const JoinGameWithIdState.initial()
      : gameId = '',
        isLoading = false,
        joiningSuccessful = null,
        backendFailure = null;

  JoinGameWithIdState copyWith({
    String? gameId,
    bool? isLoading,
    bool? joiningSuccessful,
    BackendFailure? backendFailure,
  }) {
    return JoinGameWithIdState(
      gameId: gameId ?? this.gameId,
      isLoading: isLoading ?? this.isLoading,
      joiningSuccessful: joiningSuccessful,
      backendFailure: backendFailure,
    );
  }
}
