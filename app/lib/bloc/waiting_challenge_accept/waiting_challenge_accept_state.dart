part of 'waiting_challenge_accept_bloc.dart';

@immutable
class WaitingChallengeAcceptState {
  final bool cancellationInProgress;
  final bool challengeCancelled;
  final bool challengeDeclined;

  final bool idCopiedToClipboard;

  /// Once challenge is accepted, [gameId] holds the id of the game.
  final String? gameId;

  const WaitingChallengeAcceptState({
    required this.cancellationInProgress,
    required this.challengeCancelled,
    required this.challengeDeclined,
    required this.idCopiedToClipboard,
    required this.gameId,
  });

  const WaitingChallengeAcceptState.initial()
      : cancellationInProgress = false,
        challengeCancelled = false,
        challengeDeclined = false,
        idCopiedToClipboard = false,
        gameId = null;

  WaitingChallengeAcceptState copyWith({
    bool? cancellationInProgress,
    bool? challengeCancelled,
    bool? challengeDeclined,
    bool? idCopiedToClipboard,
    String? gameId,
  }) {
    return WaitingChallengeAcceptState(
      cancellationInProgress:
          cancellationInProgress ?? this.cancellationInProgress,
      challengeCancelled: challengeCancelled ?? this.challengeCancelled,
      challengeDeclined: challengeDeclined ?? this.challengeDeclined,
      idCopiedToClipboard: idCopiedToClipboard ?? this.idCopiedToClipboard,
      gameId: gameId ?? this.gameId,
    );
  }
}
