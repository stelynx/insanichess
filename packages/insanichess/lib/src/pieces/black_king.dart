import 'black_piece.dart';
import 'piece_type.dart';

/// Represent a black king.
class BlackKing extends BlackPiece {
  const BlackKing();

  @override
  final PieceType type = PieceType.king;
}
