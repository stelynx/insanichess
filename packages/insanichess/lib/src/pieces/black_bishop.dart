import 'definitions/black_piece.dart';
import 'definitions/piece_type.dart';
import 'mixins/bishop.dart';

/// Represent a black bishop.
class BlackBishop extends BlackPiece with Bishop {
  const BlackBishop();

  @override
  final PieceType type = PieceType.bishop;
}
