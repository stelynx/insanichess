import '../pieces/black_bishop.dart';
import '../pieces/black_king.dart';
import '../pieces/black_knight.dart';
import '../pieces/black_pawn.dart';
import '../pieces/black_queen.dart';
import '../pieces/black_rook.dart';
import '../pieces/definitions/piece.dart';
import '../pieces/white_bishop.dart';
import '../pieces/white_king.dart';
import '../pieces/white_knight.dart';
import '../pieces/white_pawn.dart';
import '../pieces/white_queen.dart';
import '../pieces/white_rook.dart';
import 'move.dart';
import 'square.dart';

/// Definition of type representing a position on board.
typedef Position = List<List<Piece?>>;

/// Definition of type representing a row on the board. Used internally.
typedef _Row = List<Piece?>;

/// Representation of playing board.
///
/// Contains informaion about current [_position] and is able to perform
/// necessary operations on [_position], like [move] and [undoMove].
class Board {
  /// Current position.
  final Position _position;

  /// Size of the board. Defined for convenience.
  static const int size = 20;

  /// Constructs new `Board` object with [initialPosition].
  Board() : _position = initialPosition;

  /// Constructs new `Board` object with given [position].
  Board.fromPosition({required Position position})
      : assert(position.length == size &&
            !position.any((_Row row) => row.length != size)),
        _position = position;

  /// Returns piece at position ([row], [col]) or `null` if square is empty.
  Piece? at(int row, int col) => _position[row][col];

  /// Returns piece on [square] or `null` if square is empty.
  Piece? atSquare(Square square) => at(square.row, square.col);

  /// Performs a move [m].
  PlayedMove move(Move m) {
    final PlayedMove playedMove = PlayedMove(
      m.from,
      m.to,
      _position[m.to.row][m.to.col],
      m.promotionTo,
    );
    _position[m.to.row][m.to.col] =
        m.promotionTo ?? _position[m.from.row][m.from.col];
    _position[m.from.row][m.from.col] = null;
    return playedMove;
  }

  /// Performs a move [m], if the square [m.from] actually contains piece.
  ///
  /// This method is a more robust version of [move].
  PlayedMove? safeMove(Move m) {
    if (atSquare(m.from) == null) return null;
    return move(m);
  }

  /// Performs a [move] but in reverse order.
  void undoMove(PlayedMove move) {
    _position[move.from.row][move.from.col] = move.promotionTo == null
        ? _position[move.to.row][move.to.col]
        : _position[move.to.row][move.to.col]!.isWhite
            ? const WhitePawn()
            : const BlackPawn();
    _position[move.to.row][move.to.col] = move.pieceOnLandingSquare;
  }

  /// Performs a [move] but in reverse order, if the square [move.to] is not
  /// empty.
  ///
  /// This method is a more robust version of [undoMove].
  bool safeUndoMove(PlayedMove move) {
    if (atSquare(move.from) != null || atSquare(move.to) == null) return false;
    undoMove(move);
    return true;
  }

  /// Returns FEN representation of current [_position] on the board.
  String getFenRepresentation() {
    String s = '';
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        s += at(row, col)?.fenSymbol ?? '*';
      }
      if (row != size - 1) {
        s += '/';
      }
    }
    return s;
  }

  /// Returns a [size] by [size] looking `String` of current [_position] as
  /// viewed by white player.
  ///
  /// This function is for testing purposes only.
  String toStringAsWhite() {
    String s = '';
    for (int row = size - 1; row >= 0; row--) {
      for (int col = 0; col < size; col++) {
        s += at(row, col)?.fenSymbol ?? '*';
      }
      s += '\n';
    }
    return s;
  }

  /// Returns a [size] by [size] looking `String` of current [_position] as
  /// viewed by black player.
  ///
  /// This function is for testing purposes only.
  String toStringAsBlack() {
    String s = '';
    for (int row = 0; row < size; row++) {
      for (int col = size - 1; col >= 0; col--) {
        s += at(row, col)?.fenSymbol ?? '*';
      }
      s += '\n';
    }
    return s;
  }
}

/// Initial position.
final Position initialPosition = List<_Row>.from(
  <_Row>[
    // Row 1
    List<Piece?>.from([
      const WhiteRook(),
      const WhiteRook(),
      const WhiteBishop(),
      const WhiteBishop(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteBishop(),
      const WhiteBishop(),
      const WhiteBishop(),
      const WhiteQueen(),
      const WhiteKing(),
      const WhiteBishop(),
      const WhiteBishop(),
      const WhiteBishop(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteBishop(),
      const WhiteBishop(),
      const WhiteRook(),
      const WhiteRook(),
    ], growable: false),
    // Row 2
    List<Piece?>.from([
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteRook(),
      const WhiteRook(),
      const WhiteRook(),
      const WhiteRook(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
      const WhiteKnight(),
    ], growable: false),
    // Row 3
    List<Piece?>.from([
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
    ], growable: false),
    // Row 4
    List<Piece?>.from([
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
      const WhitePawn(),
    ], growable: false),
    // Row 5
    List.filled(Board.size, null, growable: false),
    // Row 6
    List.filled(Board.size, null, growable: false),
    // Row 7
    List.filled(Board.size, null, growable: false),
    // Row 8
    List.filled(Board.size, null, growable: false),
    // Row 9
    List.filled(Board.size, null, growable: false),
    // Row 10
    List.filled(Board.size, null, growable: false),
    // Row 11
    List.filled(Board.size, null, growable: false),
    // Row 12
    List.filled(Board.size, null, growable: false),
    // Row 13
    List.filled(Board.size, null, growable: false),
    // Row 14
    List.filled(Board.size, null, growable: false),
    // Row 15
    List.filled(Board.size, null, growable: false),
    // Row 16
    List.filled(Board.size, null, growable: false),
    // Row 17
    List<Piece?>.from([
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
    ], growable: false),
    // Row 18
    List<Piece?>.from([
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
      const BlackPawn(),
    ], growable: false),
    // Row 19
    List<Piece?>.from([
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackRook(),
      const BlackRook(),
      const BlackRook(),
      const BlackRook(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackKnight(),
    ], growable: false),
    // Row 20
    List<Piece?>.from([
      const BlackRook(),
      const BlackRook(),
      const BlackBishop(),
      const BlackBishop(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackBishop(),
      const BlackBishop(),
      const BlackBishop(),
      const BlackQueen(),
      const BlackKing(),
      const BlackBishop(),
      const BlackBishop(),
      const BlackBishop(),
      const BlackKnight(),
      const BlackKnight(),
      const BlackBishop(),
      const BlackBishop(),
      const BlackRook(),
      const BlackRook(),
    ], growable: false),
  ],
  growable: false,
);
