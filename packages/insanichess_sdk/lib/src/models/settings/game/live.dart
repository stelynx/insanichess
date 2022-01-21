import '../../../util/enum/auto_zoom_out_on_move_behaviour.dart';
import 'game.dart';

/// Model for live game settings.
class InsanichessLiveGameSettings extends InsanichessGameSettings {
  /// Creates new `InsanichessLiveGameSettings` object.
  const InsanichessLiveGameSettings({
    required bool allowUndo,
    required bool alwaysPromoteToQueen,
    required AutoZoomOutOnMoveBehaviour autoZoomOutOnMove,
  }) : super(
          allowUndo: allowUndo,
          alwaysPromoteToQueen: alwaysPromoteToQueen,
          autoZoomOutOnMove: autoZoomOutOnMove,
        );

  /// Creates new `InsanichessLiveGameSettings` object with default values.
  const InsanichessLiveGameSettings.defaults() : super.defaults();

  /// Creates new `InsanichessLiveGameSettings` object from [json].
  InsanichessLiveGameSettings.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  /// Returns a new `InsanichessLiveGameSettings` object by overriding existing field
  /// values with those given in arguments.
  @override
  InsanichessLiveGameSettings copyWith({
    bool? allowUndo,
    bool? alwaysPromoteToQueen,
    AutoZoomOutOnMoveBehaviour? autoZoomOutOnMove,
  }) {
    return InsanichessLiveGameSettings(
      allowUndo: allowUndo ?? this.allowUndo,
      alwaysPromoteToQueen: alwaysPromoteToQueen ?? this.alwaysPromoteToQueen,
      autoZoomOutOnMove: autoZoomOutOnMove ?? this.autoZoomOutOnMove,
    );
  }

  /// Returns json representation of this object.
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ...super.toJson(),
    };
  }
}

/// Keys used in `InsanichessOtbSettings` json representations.
abstract class InsanichessLiveGameSettingsJsonKey {}
