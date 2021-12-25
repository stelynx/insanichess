/// Model for OTB settings.
class InsanichessOtbSettings {
  /// Should chessboard rotate to always show the player on turn on bottom?
  final bool rotateChessboard;

  /// Should pieces on top be mirrored, e.g. if white is on bottom, then black
  /// pieces are "on their heads".
  final bool mirrorTopPieces;

  /// Creates new `InsanichessOtbSettings` object with [rotateChessboard] and
  /// [mirrorTopPieces] arguments.
  const InsanichessOtbSettings({
    required this.rotateChessboard,
    required this.mirrorTopPieces,
  });

  /// Creates new `InsanichessOtbSettings` object with default values.
  const InsanichessOtbSettings.defaults()
      : rotateChessboard = false,
        mirrorTopPieces = false;

  /// Creates new `InsanichessOtbSettings` object from [json].
  InsanichessOtbSettings.fromJson(Map<String, dynamic> json)
      : rotateChessboard = json[InsanichessOtbSettingsJsonKey.rotateChessboard],
        mirrorTopPieces = json[InsanichessOtbSettingsJsonKey.mirrorTopPieces];

  /// Returns json representation of this object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      InsanichessOtbSettingsJsonKey.rotateChessboard: rotateChessboard,
      InsanichessOtbSettingsJsonKey.mirrorTopPieces: mirrorTopPieces,
    };
  }
}

/// Keys used in `InsanichessOtbSettings` json representations.
abstract class InsanichessOtbSettingsJsonKey {
  /// Key for `InsanichessOtbSettings.rotateChessboard`.
  static const String rotateChessboard = 'rotate_chessboard';

  /// Key for `InsanichessOtbSettings.mirrorTopPieces`.
  static const String mirrorTopPieces = 'mirror_top_pieces';
}
