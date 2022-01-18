part of 'waiting_challenge_accept_bloc.dart';

@immutable
abstract class _WaitingChallengeAcceptEvent {
  const _WaitingChallengeAcceptEvent();
}

class _ChallengeExpired extends _WaitingChallengeAcceptEvent {
  const _ChallengeExpired();
}

class _CancelChallenge extends _WaitingChallengeAcceptEvent {
  const _CancelChallenge();
}
