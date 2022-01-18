/// Status of the challenge.
enum ChallengeStatus {
  /// The challenge has been created on client.
  initiated,

  /// The challenge has been created on server but not accepted / declined.
  created,

  /// The challenge has been accepted.
  accepted,

  /// The challenge has been declined.
  declined,
}

extension ChallengeStatusExtension on ChallengeStatus {
  int toJson() {
    switch (this) {
      case ChallengeStatus.initiated:
        return 0;
      case ChallengeStatus.created:
        return 1;
      case ChallengeStatus.accepted:
        return 2;
      case ChallengeStatus.declined:
        return 3;
    }
  }
}

ChallengeStatus challengeStatusFromJson(int json) {
  return ChallengeStatus.values.firstWhere(
      (ChallengeStatus challengeStatus) => challengeStatus.toJson() == json);
}
