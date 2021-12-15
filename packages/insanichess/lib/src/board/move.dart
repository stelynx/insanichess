import 'package:insanichess/src/board/square.dart';
import 'package:insanichess/src/pieces/piece.dart';

class Move {
  final Square from;
  final Square to;
  final Piece? pieceOnLandingSquare;

  const Move(this.from, this.to, this.pieceOnLandingSquare);
}
