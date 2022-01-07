import '../../../util/enum/auto_zoom_out_on_move_behaviour.dart';

/// Model for game settings.
class InsanichessGameSettings {
  /// Is undoing / takeback allowed?
  final bool allowUndo;

  /// Should pawns automatically be promoted to queen?
  final bool alwaysPromoteToQueen;

  /// Should the board be zoomed out automatically on move, and if yes, how.
  final AutoZoomOutOnMoveBehaviour autoZoomOutOnMove;

  /// Constructs new `InsanichessGameSettings` object with [allowUndo] and
  /// [alwaysPromoteToQueen].
  const InsanichessGameSettings({
    required this.allowUndo,
    required this.alwaysPromoteToQueen,
    required this.autoZoomOutOnMove,
  });

  /// Constructs new `InsanichessGameSettings` object with default values.
  const InsanichessGameSettings.defaults()
      : allowUndo = true,
        alwaysPromoteToQueen = false,
        autoZoomOutOnMove = AutoZoomOutOnMoveBehaviour.always;

  /// Constructs new `InsanichessGameSettings` object from [json].
  InsanichessGameSettings.fromJson(Map<String, dynamic> json)
      : allowUndo = json[InsanichessGameSettingsJsonKey.allowUndo],
        alwaysPromoteToQueen =
            json[InsanichessGameSettingsJsonKey.alwaysPromoteToQueen],
        autoZoomOutOnMove = autoZoomOutOnMoveBehaviourFromJson(
            json[InsanichessGameSettingsJsonKey.autoZoomOutOnMove]);

  /// Returns a new `InsanichessGameSettings` object by overriding existing
  /// field values with those given in arguments.
  InsanichessGameSettings copyWith({
    bool? allowUndo,
    bool? alwaysPromoteToQueen,
    AutoZoomOutOnMoveBehaviour? autoZoomOutOnMove,
  }) {
    return InsanichessGameSettings(
      allowUndo: allowUndo ?? this.allowUndo,
      alwaysPromoteToQueen: alwaysPromoteToQueen ?? this.alwaysPromoteToQueen,
      autoZoomOutOnMove: autoZoomOutOnMove ?? this.autoZoomOutOnMove,
    );
  }

  /// Converts this object to json representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      InsanichessGameSettingsJsonKey.allowUndo: allowUndo,
      InsanichessGameSettingsJsonKey.alwaysPromoteToQueen: alwaysPromoteToQueen,
      InsanichessGameSettingsJsonKey.autoZoomOutOnMove:
          autoZoomOutOnMove.toJson(),
    };
  }
}

/// Keys used in `InsanichessOtbSettings` json representations.
abstract class InsanichessGameSettingsJsonKey {
  /// Key for `InsanichessGameSettings.allowUndo`.
  static const String allowUndo = 'allow_undo';

  /// Key for `InsanichessGameSettings.alwaysPromoteToQueen`.
  static const String alwaysPromoteToQueen = 'always_promote_to_queen';

  /// Key for `InsanichessSettings.autoZoomOutOnMove`.
  static const String autoZoomOutOnMove = 'auto_zoom_out_on_move';
}
