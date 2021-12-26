import 'game.dart';

/// Model for OTB settings.
class InsanichessOtbSettings extends InsanichessGameSettings {
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
    required bool allowUndo,
    required bool alwaysPromoteToQueen,
  }) : super(
          allowUndo: allowUndo,
          alwaysPromoteToQueen: alwaysPromoteToQueen,
        );

  /// Creates new `InsanichessOtbSettings` object with default values.
  const InsanichessOtbSettings.defaults()
      : rotateChessboard = false,
        mirrorTopPieces = false,
        super.defaults();

  /// Creates new `InsanichessOtbSettings` object from [json].
  InsanichessOtbSettings.fromJson(Map<String, dynamic> json)
      : rotateChessboard = json[InsanichessOtbSettingsJsonKey.rotateChessboard],
        mirrorTopPieces = json[InsanichessOtbSettingsJsonKey.mirrorTopPieces],
        super.fromJson(json);

  /// Returns json representation of this object.
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      InsanichessOtbSettingsJsonKey.rotateChessboard: rotateChessboard,
      InsanichessOtbSettingsJsonKey.mirrorTopPieces: mirrorTopPieces,
      ...super.toJson(),
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
