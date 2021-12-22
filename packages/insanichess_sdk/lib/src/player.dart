/// A player of the game.
///
/// This class contains all the necessary data for a player / user.
class InsanichessPlayer {
  /// The username of the player.
  final String username;

  /// Constructs new `InsanichessPlayer` with given [username].
  const InsanichessPlayer({required this.username});

  /// Constructs new `InsanichessPlayer` for testing purposes.
  const InsanichessPlayer.testWhite() : username = 'White';

  /// Constructs new `InsanichessPlayer` for testing purposes.
  const InsanichessPlayer.testBlack() : username = 'Black';
}
