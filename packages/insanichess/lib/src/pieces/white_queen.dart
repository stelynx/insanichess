import 'definitions/piece_type.dart';
import 'definitions/white_piece.dart';
import 'mixins/queen.dart';

/// Represent a white queen.
class WhiteQueen extends WhitePiece with Queen {
  const WhiteQueen();

  @override
  final PieceType type = PieceType.queen;
}
