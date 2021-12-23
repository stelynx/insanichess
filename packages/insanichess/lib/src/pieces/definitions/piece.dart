import '../../../insanichess.dart';
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

  /// Returns the list of possible moves with this piece from [square],
  /// including moves that are illegal in current position.
  List<Move> getPossibleMovesFromSquareOnBoard(Square square, Board board);

  /// Returns `true` if this piece is white.
  bool get isWhite => color == PieceColor.white;

  /// Returns `true` if this piece is black.
  bool get isBlack => color == PieceColor.black;

  /// Returns FEN symbol for this piece.
  String get fenSymbol {
    return isWhite ? type.fenSymbol.toUpperCase() : type.fenSymbol;
  }

  /// Creates an appropriate piece for [fenSymbol].
  static Piece fromFenSymbol(String fenSymbol) {
    final bool isWhite = fenSymbol == fenSymbol.toUpperCase();

    switch (fenSymbol.toLowerCase()) {
      case 'p':
        return isWhite ? const WhitePawn() : const BlackPawn();
      case 'r':
        return isWhite ? const WhiteRook() : const BlackRook();
      case 'n':
        return isWhite ? const WhiteKnight() : const BlackKnight();
      case 'b':
        return isWhite ? const WhiteBishop() : const BlackBishop();
      case 'q':
        return isWhite ? const WhiteQueen() : const BlackQueen();
      case 'k':
        return isWhite ? const WhiteKing() : const BlackKing();
      default:
        throw ArgumentError('Unknown FEN symbol "$fenSymbol"');
    }
  }
}
