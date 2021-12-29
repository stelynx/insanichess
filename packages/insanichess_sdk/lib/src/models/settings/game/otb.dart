import '../../../util/enum/auto_zoom_out_on_move_behaviour.dart';
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
    required AutoZoomOutOnMoveBehaviour autoZoomOutOnMove,
  }) : super(
          allowUndo: allowUndo,
          alwaysPromoteToQueen: alwaysPromoteToQueen,
          autoZoomOutOnMove: autoZoomOutOnMove,
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

  /// Returns a new `InsanichessOtbSettings` object by overriding existing field
  /// values with those given in arguments.
  @override
  InsanichessOtbSettings copyWith({
    bool? rotateChessboard,
    bool? mirrorTopPieces,
    bool? allowUndo,
    bool? alwaysPromoteToQueen,
    AutoZoomOutOnMoveBehaviour? autoZoomOutOnMove,
  }) {
    return InsanichessOtbSettings(
      rotateChessboard: rotateChessboard ?? this.rotateChessboard,
      mirrorTopPieces: mirrorTopPieces ?? this.mirrorTopPieces,
      allowUndo: allowUndo ?? this.allowUndo,
      alwaysPromoteToQueen: alwaysPromoteToQueen ?? this.alwaysPromoteToQueen,
      autoZoomOutOnMove: autoZoomOutOnMove ?? this.autoZoomOutOnMove,
    );
  }

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
