import '../pieces/piece.dart';
import 'square.dart';

class Move {
  final Square from;
  final Square to;
  final Piece? pieceOnLandingSquare;

  const Move(this.from, this.to, this.pieceOnLandingSquare);

  String toICString() => '${from.toICString()}-${to.toICString()}';
}
