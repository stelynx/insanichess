import 'package:insanichess_sdk/insanichess_sdk.dart';

/// Globally accessible memory.
final Memory memory = Memory();

/// In-memory storage for server.
class Memory {
  /// List of currently opened challenges.
  final Map<String, InsanichessChallenge> openChallenges =
      <String, InsanichessChallenge>{};

  /// List of games currently in progress.
  final List<InsanichessGame> gamesInProgress = <InsanichessGame>[];
}
