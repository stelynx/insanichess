import 'package:insanichess/insanichess.dart' as insanichess;

extension PieceExtension on insanichess.Piece {
  String getImagePath() {
    return 'assets/images/chess_pieces/${type.fenSymbol}${isWhite ? 'w' : 'b'}.svg';
  }
}
