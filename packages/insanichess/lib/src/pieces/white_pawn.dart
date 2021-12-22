import 'piece_type.dart';
import 'white_piece.dart';

/// Represent a white pawn.
class WhitePawn extends WhitePiece {
  const WhitePawn();

  @override
  final PieceType type = PieceType.pawn;
}
