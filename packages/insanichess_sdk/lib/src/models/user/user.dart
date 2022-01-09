import '../insanichess_model.dart';

/// Model representing base user info.
class InsanichessUser implements InsanichessModel {
  /// The id of the user.
  final String id;

  /// The email of the user.
  final String email;

  /// The password of the user, PLAIN.
  final String? password;

  /// Constructs new `InsanichessUser` object with [id], [email], and optional
  /// [appleId].
  const InsanichessUser({
    required this.id,
    required this.email,
    this.password,
  });

  /// Constructs new `InsanichessUser` object from [json].
  InsanichessUser.fromJson(Map<String, dynamic> json)
      : id = json[InsanichessUserJsonKey.id],
        email = json[InsanichessUserJsonKey.email],
        password = json[InsanichessUserJsonKey.password];

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessUserJsonKey.id: id,
      InsanichessUserJsonKey.email: email,
      if (password != null) InsanichessUserJsonKey.password: password,
    };
  }
}

/// Keys used in `InsanichessUserJsonKey` json representations.
abstract class InsanichessUserJsonKey {
  /// Key for `InsanichessUser.id`.
  static const String id = 'id';

  /// Key for `InsanichessUser.email`.
  static const String email = 'email';

  /// Key for `InsanichessUser.password`.
  static const String password = 'password';
}
