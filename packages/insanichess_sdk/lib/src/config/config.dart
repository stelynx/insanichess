/// Holds configuration fields that both client and server need or share.
abstract class InsanichessConfig {
  /// Duration in which white has to perform a move before or else the game is
  /// disbanded.
  static const Duration whiteForFirstMove = Duration(seconds: 30);

  /// The duration in which a private challenge needs to be accepted before it
  /// is cancelled by the server.
  static const Duration expirePrivateChallengeAfter = Duration(minutes: 2);

  /// The duration in which a public challenge needs to be matchmade before it
  /// is cancelled by the server.
  static const Duration expirePublicChallengeAfter = Duration(hours: 1);
}
