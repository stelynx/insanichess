import 'definitions/piece_type.dart';
import 'definitions/white_piece.dart';
import 'mixins/king.dart';

/// Represent a white king.
class WhiteKing extends WhitePiece with King {
  const WhiteKing();

  @override
  final PieceType type = PieceType.king;
}
