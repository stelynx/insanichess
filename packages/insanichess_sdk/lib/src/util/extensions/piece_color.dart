import 'package:insanichess/insanichess.dart' as insanichess;

/// Extends [insanichess.PieceColor] with additional functionality.
extension PieceColorExtension on insanichess.PieceColor {
  /// Converts [insanichess.PieceColor] to json representation.
  String toJson() {
    switch (this) {
      case insanichess.PieceColor.white:
        return 'w';
      case insanichess.PieceColor.black:
        return 'b';
    }
  }
}

/// Returns appropriate [insanichess.PieceColor] from [json] representation.
insanichess.PieceColor pieceColorFromJson(String json) {
  switch (json) {
    case 'w':
      return insanichess.PieceColor.white;
    case 'b':
      return insanichess.PieceColor.black;
    default:
      throw UnsupportedError('Unknown piece color "$json"');
  }
}
