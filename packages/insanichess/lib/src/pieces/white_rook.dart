import 'piece_type.dart';
import 'white_piece.dart';

/// Represent a white rook.
class WhiteRook extends WhitePiece {
  const WhiteRook();

  @override
  final PieceType type = PieceType.rook;
}
