import 'definitions/black_piece.dart';
import 'definitions/piece_type.dart';
import 'mixins/knight.dart';

/// Represent a black knight.
class BlackKnight extends BlackPiece with Knight {
  const BlackKnight();

  @override
  final PieceType type = PieceType.knight;
}
