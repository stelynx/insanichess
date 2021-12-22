import 'definitions/piece_type.dart';
import 'definitions/white_piece.dart';
import 'mixins/bishop.dart';

/// Represent a white bishop.
class WhiteBishop extends WhitePiece with Bishop {
  const WhiteBishop();

  @override
  final PieceType type = PieceType.bishop;
}
