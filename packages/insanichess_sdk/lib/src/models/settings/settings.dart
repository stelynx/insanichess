import 'otb.dart';

/// Model for all settings for the app.
class InsanichessSettings {
  /// OTB settings.
  final InsanichessOtbSettings otb;

  /// Creates new `InsanichessSettings` object, with [otb] settings.
  const InsanichessSettings({required this.otb});

  /// Creates new `InsanichessSettings` object with default values.
  const InsanichessSettings.defaults()
      : otb = const InsanichessOtbSettings.defaults();

  /// Creates new `InsanichessSettings` from [json] representation.
  InsanichessSettings.fromJson(Map<String, dynamic> json)
      : otb = InsanichessOtbSettings.fromJson(
            json[InsanichessSettingsJsonKey.otb]);

  /// Converts this object to json representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      InsanichessSettingsJsonKey.otb: otb.toJson(),
    };
  }
}

/// Keys used in `InsanichessOtbSettings` json representations.
abstract class InsanichessSettingsJsonKey {
  /// Key for `InsanichessSettings.otb`.
  static const String otb = 'otb';
}
