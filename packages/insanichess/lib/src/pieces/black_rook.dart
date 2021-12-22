import 'definitions/black_piece.dart';
import 'definitions/piece_type.dart';
import 'mixins/rook.dart';

/// Represent a black rook.
class BlackRook extends BlackPiece with Rook {
  const BlackRook();

  @override
  final PieceType type = PieceType.rook;
}
