import 'definitions/piece_type.dart';
import 'definitions/white_piece.dart';
import 'mixins/knight.dart';

/// Represent a white knight.
class WhiteKnight extends WhitePiece with Knight {
  const WhiteKnight();

  @override
  final PieceType type = PieceType.knight;
}
