import 'definitions/black_piece.dart';
import 'definitions/piece_type.dart';
import 'mixins/pawn.dart';

/// Represent a black pawn.
class BlackPawn extends BlackPiece with Pawn {
  const BlackPawn();

  @override
  final PieceType type = PieceType.pawn;
}
