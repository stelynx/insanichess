import 'piece_type.dart';
import 'white_piece.dart';

/// Represent a white king.
class WhiteKing extends WhitePiece {
  const WhiteKing();

  @override
  final PieceType type = PieceType.king;
}
