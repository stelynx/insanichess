import '../insanichess_model.dart';
import 'game/live.dart';
import 'game/otb.dart';

/// Model for all settings for the app.
class InsanichessSettings implements InsanichessDatabaseModel {
  /// OTB settings.
  final InsanichessOtbSettings otb;

  /// Live game settings.
  final InsanichessLiveGameSettings live;

  /// Should zoom-out button be on the left side of screen.
  final bool showZoomOutButtonOnLeft;

  /// When a piece is selected, should we show legal moves with that piece.
  final bool showLegalMoves;

  /// Creates new `InsanichessSettings` object.
  const InsanichessSettings({
    required this.otb,
    required this.live,
    required this.showZoomOutButtonOnLeft,
    required this.showLegalMoves,
  });

  /// Creates new `InsanichessSettings` object with default values.
  const InsanichessSettings.defaults()
      : otb = const InsanichessOtbSettings.defaults(),
        live = const InsanichessLiveGameSettings.defaults(),
        showZoomOutButtonOnLeft = true,
        showLegalMoves = true;

  /// Creates new `InsanichessSettings` from [json] representation.
  InsanichessSettings.fromJson(Map<String, dynamic> json)
      : otb = InsanichessOtbSettings.fromJson(
            json[InsanichessSettingsJsonKey.otb]),
        live = InsanichessLiveGameSettings.fromJson(
            json[InsanichessSettingsJsonKey.live]),
        showZoomOutButtonOnLeft =
            json[InsanichessSettingsJsonKey.showZoomOutButtonOnLeft],
        showLegalMoves = json[InsanichessSettingsJsonKey.showLegalMoves];

  /// Returns a new `InsanichessSettings` object by overriding existing field
  /// values with those given in arguments.
  InsanichessSettings copyWith({
    InsanichessOtbSettings? otb,
    InsanichessLiveGameSettings? live,
    bool? showZoomOutButtonOnLeft,
    bool? showLegalMoves,
  }) {
    return InsanichessSettings(
      otb: otb ?? this.otb,
      live: live ?? this.live,
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
      InsanichessSettingsJsonKey.live: live.toJson(),
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

  /// Key for `InsanichessSettings.live`.
  static const String live = 'live';

  /// Key for `InsanichessSettings.showZoomOutButtonOnLeft`.
  static const String showZoomOutButtonOnLeft = 'show_zoom_out_button_on_left';

  /// Key for `InsanichessSettings.showLegalMoves`.
  static const String showLegalMoves = 'show_legal_moves';
}
