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

class _FetchChallengeData extends _WaitingChallengeAcceptEvent {
  const _FetchChallengeData();
}

class _CopyIdToClipboard extends _WaitingChallengeAcceptEvent {
  const _CopyIdToClipboard();
}
