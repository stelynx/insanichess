import 'package:insanichess/src/pieces/piece.dart';
import 'package:insanichess/src/pieces/piece_color.dart';

abstract class BlackPiece extends Piece {
  const BlackPiece();

  @override
  final PieceColor color = PieceColor.black;

  @override
  final bool isWhite = false;

  @override
  final bool isBlack = true;
}
