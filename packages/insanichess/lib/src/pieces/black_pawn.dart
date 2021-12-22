import 'black_piece.dart';
import 'piece_type.dart';

/// Represent a black pawn.
class BlackPawn extends BlackPiece {
  const BlackPawn();

  @override
  final PieceType type = PieceType.pawn;
}
