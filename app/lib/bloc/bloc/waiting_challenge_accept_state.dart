part of 'waiting_challenge_accept_bloc.dart';

@immutable
class WaitingChallengeAcceptState {
  final bool cancellationInProgress;
  final bool challengeCancelled;
  final bool challengeDeclined;

  /// Once challenge is accepted, [gameId] holds the id of the game.
  final String? gameId;

  const WaitingChallengeAcceptState({
    required this.cancellationInProgress,
    required this.challengeCancelled,
    required this.challengeDeclined,
    required this.gameId,
  });

  const WaitingChallengeAcceptState.initial()
      : cancellationInProgress = false,
        challengeCancelled = false,
        challengeDeclined = false,
        gameId = null;

  WaitingChallengeAcceptState copyWith({
    bool? cancellationInProgress,
    bool? challengeCancelled,
    bool? challengeDeclined,
    String? gameId,
  }) {
    return WaitingChallengeAcceptState(
      cancellationInProgress:
          cancellationInProgress ?? this.cancellationInProgress,
      challengeCancelled: challengeCancelled ?? this.challengeCancelled,
      challengeDeclined: challengeDeclined ?? this.challengeDeclined,
      gameId: gameId ?? this.gameId,
    );
  }
}
