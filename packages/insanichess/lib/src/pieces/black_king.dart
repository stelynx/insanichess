import 'definitions/black_piece.dart';
import 'definitions/piece_type.dart';
import 'mixins/king.dart';

/// Represent a black king.
class BlackKing extends BlackPiece with King {
  const BlackKing();

  @override
  final PieceType type = PieceType.king;
}
