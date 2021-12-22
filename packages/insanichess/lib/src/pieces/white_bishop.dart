import 'piece_type.dart';
import 'white_piece.dart';

/// Represent a white bishop.
class WhiteBishop extends WhitePiece {
  const WhiteBishop();

  @override
  final PieceType type = PieceType.bishop;
}
