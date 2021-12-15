import 'package:insanichess/src/pieces/piece_color.dart';
import 'package:insanichess/src/pieces/piece_type.dart';

abstract class Piece {
  const Piece();

  PieceType get type;

  PieceColor get color;

  bool get isWhite => color == PieceColor.white;
  bool get isBlack => color == PieceColor.black;

  String get fenSymbol {
    return isWhite ? type.fenSymbol.toUpperCase() : type.fenSymbol;
  }
}
