import 'definitions/piece_type.dart';
import 'definitions/white_piece.dart';
import 'mixins/rook.dart';

/// Represent a white rook.
class WhiteRook extends WhitePiece with Rook {
  const WhiteRook();

  @override
  final PieceType type = PieceType.rook;
}
