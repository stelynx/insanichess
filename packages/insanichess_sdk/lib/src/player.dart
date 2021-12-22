/// A player of the game.
///
/// This class contains all the necessary data for a player / user.
class InsanichessPlayer {
  /// The id of the player.
  final String id;

  /// The username of the player.
  final String username;

  /// Constructs new `InsanichessPlayer` with given [id] and [username].
  const InsanichessPlayer({required this.id, required this.username});

  /// Constructs new `InsanichessPlayer` for testing purposes.
  const InsanichessPlayer.testWhite()
      : id = 'White',
        username = 'White';

  /// Constructs new `InsanichessPlayer` for testing purposes.
  const InsanichessPlayer.testBlack()
      : id = 'Black',
        username = 'Black';
}
