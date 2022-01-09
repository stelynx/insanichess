import '../insanichess_model.dart';

/// Model representing base user info.
class InsanichessUser implements InsanichessModel {
  /// The id of the user.
  final String id;

  /// The email of the user.
  final String email;

  /// The password of the user, PLAIN.
  final String? password;

  /// JWT token corresponding to user.
  final String? jwtToken;

  /// Constructs new `InsanichessUser` object with [id], [email], and optional
  /// [password] and [jwtToken].
  const InsanichessUser({
    required this.id,
    required this.email,
    this.password,
    this.jwtToken,
  });

  /// Constructs new `InsanichessUser` object from [json].
  InsanichessUser.fromJson(Map<String, dynamic> json)
      : id = json[InsanichessUserJsonKey.id],
        email = json[InsanichessUserJsonKey.email],
        password = json[InsanichessUserJsonKey.password],
        jwtToken = json[InsanichessUserJsonKey.jwtToken];

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessUserJsonKey.id: id,
      InsanichessUserJsonKey.email: email,
      if (password != null) InsanichessUserJsonKey.password: password,
      if (jwtToken != null) InsanichessUserJsonKey.jwtToken: jwtToken,
    };
  }

  /// Returns new instance of `InsanichessUser` with modified fields.
  InsanichessUser copyWith({
    String? id,
    String? email,
    String? jwtToken,
  }) {
    return InsanichessUser(
      id: id ?? this.id,
      email: email ?? this.email,
      jwtToken: jwtToken,
    );
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

  /// Key for `InsanichessUser.jwtToken`.
  static const String jwtToken = 'jwtToken';
}
