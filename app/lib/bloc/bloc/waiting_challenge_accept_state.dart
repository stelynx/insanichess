part of 'waiting_challenge_accept_bloc.dart';

@immutable
class WaitingChallengeAcceptState {
  final bool cancellationInProgress;
  final bool challengeCancelled;

  const WaitingChallengeAcceptState({
    required this.cancellationInProgress,
    required this.challengeCancelled,
  });

  const WaitingChallengeAcceptState.initial()
      : cancellationInProgress = false,
        challengeCancelled = false;

  WaitingChallengeAcceptState copyWith({
    bool? cancellationInProgress,
    bool? challengeCancelled,
  }) {
    return WaitingChallengeAcceptState(
      cancellationInProgress:
          cancellationInProgress ?? this.cancellationInProgress,
      challengeCancelled: challengeCancelled ?? this.challengeCancelled,
    );
  }
}
