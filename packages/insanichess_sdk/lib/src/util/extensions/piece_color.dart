import 'package:insanichess/insanichess.dart' as insanichess;

extension PieceColorExtension on insanichess.PieceColor {
  String toJson() {
    switch (this) {
      case insanichess.PieceColor.white:
        return 'w';
      case insanichess.PieceColor.black:
        return 'b';
    }
  }
}
