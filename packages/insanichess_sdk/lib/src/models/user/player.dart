import 'user.dart';

/// A player of the game.
///
/// This class contains all the necessary data for a player / user.
class InsanichessPlayer extends InsanichessUser {
  /// The username of the player.
  final String username;

  /// Constructs new `InsanichessPlayer` with given [id] and [username].
  const InsanichessPlayer(
      {required String id, required String email, required this.username})
      : super(id: id, email: email);

  /// Constructs new `InsanichessPlayer` from [json].
  InsanichessPlayer.fromJson(Map<String, dynamic> json)
      : username = json[InsanichessPlayerJsonKey.username],
        super.fromJson(json);

  /// Constructs new `InsanichessPlayer` for testing purposes.
  const InsanichessPlayer.testWhite()
      : username = 'White',
        super(id: 'White', email: 'white@g.c');

  /// Constructs new `InsanichessPlayer` for testing purposes.
  const InsanichessPlayer.testBlack()
      : username = 'Black',
        super(id: 'Black', email: 'black@g.c');

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessPlayerJsonKey.username: username,
      ...super.toJson(),
    };
  }
}

/// Keys used in `InsanichessPlayerJsonKey` json representations.
abstract class InsanichessPlayerJsonKey {
  /// Key for `InsanichessPlayer.username`.
  static const String username = 'username';
}
