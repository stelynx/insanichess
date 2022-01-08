import '../insanichess_model.dart';

/// Model representing base user info.
class InsanichessUser implements InsanichessModel {
  /// The id of the user.
  final String id;

  /// The email of the user.
  final String email;

  /// The Apple ID in case user registered with Apple.
  final String? appleId;

  /// Constructs new `InsanichessUser` object with [id], [email], and optional
  /// [appleId].
  const InsanichessUser({
    required this.id,
    required this.email,
    this.appleId,
  });

  /// Constructs new `InsanichessUser` object from [json].
  InsanichessUser.fromJson(Map<String, dynamic> json)
      : id = json[InsanichessUserJsonKey.id],
        email = json[InsanichessUserJsonKey.email],
        appleId = json[InsanichessUserJsonKey.appleId];

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessUserJsonKey.id: id,
      InsanichessUserJsonKey.email: email,
      InsanichessUserJsonKey.appleId: appleId,
    };
  }
}

/// Keys used in `InsanichessUserJsonKey` json representations.
abstract class InsanichessUserJsonKey {
  /// Key for `InsanichessUser.id`.
  static const String id = 'id';

  /// Key for `InsanichessUser.email`.
  static const String email = 'email';

  /// Key for `InsanichessUser.appleId`.
  static const String appleId = 'apple_id';
}
