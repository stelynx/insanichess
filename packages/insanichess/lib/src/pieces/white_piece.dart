import 'package:insanichess/src/pieces/piece.dart';
import 'package:insanichess/src/pieces/piece_color.dart';

abstract class WhitePiece extends Piece {
  const WhitePiece();

  @override
  final PieceColor color = PieceColor.white;

  @override
  final bool isWhite = true;

  @override
  final bool isBlack = false;
}
