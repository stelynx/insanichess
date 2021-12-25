import 'package:insanichess/insanichess.dart' as insanichess;

extension PieceExtension on insanichess.Piece {
  String getImagePath({bool mirrored = false}) {
    return 'assets/images/chess_pieces/${type.fenSymbol}${isWhite ? 'w' : 'b'}${mirrored ? 'r' : ''}.svg';
  }
}
