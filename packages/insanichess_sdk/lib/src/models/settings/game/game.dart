import 'package:flutter/foundation.dart';

/// Model for game settings.
class InsanichessGameSettings {
  /// Is undoing / takeback allowed?
  final bool allowUndo;

  /// Should pawns automatically be promoted to queen?
  final bool alwaysPromoteToQueen;

  /// Constructs new `InsanichessGameSettings` object with [allowUndo] and
  /// [alwaysPromoteToQueen].
  const InsanichessGameSettings({
    required this.allowUndo,
    required this.alwaysPromoteToQueen,
  });

  /// Constructs new `InsanichessGameSettings` object with default values.
  const InsanichessGameSettings.defaults()
      : allowUndo = true,
        alwaysPromoteToQueen = false;

  /// Constructs new `InsanichessGameSettings` object from [json].
  InsanichessGameSettings.fromJson(Map<String, dynamic> json)
      : allowUndo = json[InsanichessGameSettingsJsonKey.allowUndo],
        alwaysPromoteToQueen =
            json[InsanichessGameSettingsJsonKey.alwaysPromoteToQueen];

  /// Converts this object to json representation.
  @mustCallSuper
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      InsanichessGameSettingsJsonKey.allowUndo: allowUndo,
      InsanichessGameSettingsJsonKey.alwaysPromoteToQueen: alwaysPromoteToQueen,
    };
  }
}

/// Keys used in `InsanichessOtbSettings` json representations.
abstract class InsanichessGameSettingsJsonKey {
  /// Key for `InsanichessGameSettings.allowUndo`.
  static const String allowUndo = 'allow_undo';

  /// Key for `InsanichessGameSettings.alwaysPromoteToQueen`.
  static const String alwaysPromoteToQueen = 'always_promote_to_queen';
}
