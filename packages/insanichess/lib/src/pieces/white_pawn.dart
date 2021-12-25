import 'definitions/piece_type.dart';
import 'definitions/white_piece.dart';
import 'mixins/pawn.dart';

/// Represent a white pawn.
class WhitePawn extends WhitePiece with Pawn {
  const WhitePawn();

  @override
  final PieceType type = PieceType.pawn;
}
