import 'package:insanichess_sdk/insanichess_sdk.dart';

/// Globally accessible memory.
final Memory memory = Memory();

/// In-memory storage for server.
class Memory {
  /// List of currently opened challenges.
  ///
  /// A map from ids to corresponding challenges.
  final Map<String, InsanichessChallenge> openChallenges =
      <String, InsanichessChallenge>{};

  /// List of games currently in progress.
  ///
  /// A map from temporary ids to corresponding games. `InsanichessGame` also
  /// contains the id, however this implementation is purely for convenience and
  /// better performance when querying by id.
  final Map<String, InsanichessGame> gamesInProgress =
      <String, InsanichessGame>{};
}
