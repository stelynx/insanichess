import '../insanichess_model.dart';
import 'game/otb.dart';

/// Model for all settings for the app.
class InsanichessSettings implements InsanichessModel {
  /// OTB settings.
  final InsanichessOtbSettings otb;

  /// Should zoom-out button be on the left side of screen.
  final bool showZoomOutButtonOnLeft;

  /// When a piece is selected, should we show legal moves with that piece.
  final bool showLegalMoves;

  /// Creates new `InsanichessSettings` object.
  const InsanichessSettings({
    required this.otb,
    required this.showZoomOutButtonOnLeft,
    required this.showLegalMoves,
  });

  /// Creates new `InsanichessSettings` object with default values.
  const InsanichessSettings.defaults()
      : otb = const InsanichessOtbSettings.defaults(),
        showZoomOutButtonOnLeft = true,
        showLegalMoves = true;

  /// Creates new `InsanichessSettings` from [json] representation.
  InsanichessSettings.fromJson(Map<String, dynamic> json)
      : otb = InsanichessOtbSettings.fromJson(
            json[InsanichessSettingsJsonKey.otb]),
        showZoomOutButtonOnLeft =
            json[InsanichessSettingsJsonKey.showZoomOutButtonOnLeft],
        showLegalMoves = json[InsanichessSettingsJsonKey.showLegalMoves];

  /// Returns a new `InsanichessSettings` object by overriding existing field
  /// values with those given in arguments.
  InsanichessSettings copyWith({
    InsanichessOtbSettings? otb,
    bool? showZoomOutButtonOnLeft,
    bool? showLegalMoves,
  }) {
    return InsanichessSettings(
      otb: otb ?? this.otb,
      showZoomOutButtonOnLeft:
          showZoomOutButtonOnLeft ?? this.showZoomOutButtonOnLeft,
      showLegalMoves: showLegalMoves ?? this.showLegalMoves,
    );
  }

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, dynamic>{
      InsanichessSettingsJsonKey.otb: otb.toJson(),
      InsanichessSettingsJsonKey.showZoomOutButtonOnLeft:
          showZoomOutButtonOnLeft,
      InsanichessSettingsJsonKey.showLegalMoves: showLegalMoves,
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
}
