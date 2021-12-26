import '../../util/enum/auto_zoom_out_on_move_behaviour.dart';
import 'game/otb.dart';

/// Model for all settings for the app.
class InsanichessSettings {
  /// OTB settings.
  final InsanichessOtbSettings otb;

  /// Should zoom-out button be on the left side of screen.
  final bool showZoomOutButtonOnLeft;

  /// When a piece is selected, should we show legal moves with that piece.
  final bool showLegalMoves;

  /// If a piece is selected and only one legal move can be played with it,
  /// should that move be automatically performed?
  final bool autoMoveIfOneLegalMove;

  /// Should the board be zoomed out automatically on move, and if yes, how.
  final AutoZoomOutOnMoveBehaviour autoZoomOutOnMove;

  /// Creates new `InsanichessSettings` object.
  const InsanichessSettings({
    required this.otb,
    required this.showZoomOutButtonOnLeft,
    required this.showLegalMoves,
    required this.autoMoveIfOneLegalMove,
    required this.autoZoomOutOnMove,
  });

  /// Creates new `InsanichessSettings` object with default values.
  const InsanichessSettings.defaults()
      : otb = const InsanichessOtbSettings.defaults(),
        showZoomOutButtonOnLeft = true,
        showLegalMoves = true,
        autoMoveIfOneLegalMove = true,
        autoZoomOutOnMove = AutoZoomOutOnMoveBehaviour.onMyMove;

  /// Creates new `InsanichessSettings` from [json] representation.
  InsanichessSettings.fromJson(Map<String, dynamic> json)
      : otb = InsanichessOtbSettings.fromJson(
            json[InsanichessSettingsJsonKey.otb]),
        showZoomOutButtonOnLeft =
            json[InsanichessSettingsJsonKey.showZoomOutButtonOnLeft],
        showLegalMoves = json[InsanichessSettingsJsonKey.showLegalMoves],
        autoMoveIfOneLegalMove =
            json[InsanichessSettingsJsonKey.autoMoveIfOneLegalMove],
        autoZoomOutOnMove = autoZoomOutOnMoveBehaviourFromJson(
            json[InsanichessSettingsJsonKey.autoZoomOutOnMove]);

  /// Converts this object to json representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      InsanichessSettingsJsonKey.otb: otb.toJson(),
      InsanichessSettingsJsonKey.showZoomOutButtonOnLeft:
          showZoomOutButtonOnLeft,
      InsanichessSettingsJsonKey.showLegalMoves: showLegalMoves,
      InsanichessSettingsJsonKey.autoMoveIfOneLegalMove: autoMoveIfOneLegalMove,
      InsanichessSettingsJsonKey.autoZoomOutOnMove: autoZoomOutOnMove.toJson(),
    };
  }
}

/// Keys used in `InsanichessOtbSettings` json representations.
abstract class InsanichessSettingsJsonKey {
  /// Key for `InsanichessSettings.otb`.
  static const String otb = 'otb';

  /// Key for `InsanichessSettings.showZoomOutButtonOnLeft`.
  static const String showZoomOutButtonOnLeft = 'show_zoom_out_button_on_left';

  /// Key for `InsanichessSettings.showLegalMoves`.
  static const String showLegalMoves = 'show_legal_moves';

  /// Key for `InsanichessSettings.autoMoveIfOneLegalMove`.
  static const String autoMoveIfOneLegalMove = 'auto_move_if_one_legal_move';

  /// Key for `InsanichessSettings.autoZoomOutOnMove`.
  static const String autoZoomOutOnMove = 'auto_zoom_out_on_move';
}
