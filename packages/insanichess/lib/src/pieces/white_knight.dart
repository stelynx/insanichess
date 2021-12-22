import 'piece_type.dart';
import 'white_piece.dart';

/// Represent a white knight.
class WhiteKnight extends WhitePiece {
  const WhiteKnight();

  @override
  final PieceType type = PieceType.knight;
}
