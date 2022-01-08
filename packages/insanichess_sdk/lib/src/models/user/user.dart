import '../insanichess_model.dart';

/// Model representing base user info.
class InsanichessUser implements InsanichessModel {
  /// The id of the player.
  final String id;

  /// The email of the player.
  final String email;

  /// Constructs new `InsanichessUser` object with [id] and [email].
  const InsanichessUser({required this.id, required this.email});

  /// Constructs new `InsanichessUser` object from [json].
  InsanichessUser.fromJson(Map<String, dynamic> json)
      : id = json[InsanichessUserJsonKey.id],
        email = json[InsanichessUserJsonKey.email];

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessUserJsonKey.id: id,
      InsanichessUserJsonKey.email: email,
    };
  }
}

/// Keys used in `InsanichessUserJsonKey` json representations.
abstract class InsanichessUserJsonKey {
  /// Key for `InsanichessUser.id`.
  static const String id = 'id';

  /// Key for `InsanichessUser.email`.
  static const String email = 'email';
}
