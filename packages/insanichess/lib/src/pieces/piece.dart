import 'piece_color.dart';
import 'piece_type.dart';

/// [Piece] represents a game piece. It contains information of what [type] this
/// piece is (e.g. pawn, knight, etc.) and what [color] it is.
abstract class Piece {
  /// Const constructor for overrided members to be able to have const
  /// constructors.
  const Piece();

  /// [type] of the piece, e.g. pawn, knight, etc.
  PieceType get type;

  /// [color] of the piece.
  PieceColor get color;

  /// Returns `true` if this piece is white.
  bool get isWhite => color == PieceColor.white;

  /// Returns `true` if this piece is black.
  bool get isBlack => color == PieceColor.black;

  /// Returns FEN symbol for this piece.
  String get fenSymbol {
    return isWhite ? type.fenSymbol.toUpperCase() : type.fenSymbol;
  }
}
