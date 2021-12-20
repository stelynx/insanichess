import 'package:flutter/foundation.dart';

import '../pieces/black_bishop.dart';
import '../pieces/black_king.dart';
import '../pieces/black_knight.dart';
import '../pieces/black_pawn.dart';
import '../pieces/black_queen.dart';
import '../pieces/black_rook.dart';
import '../pieces/piece.dart';
import '../pieces/white_bishop.dart';
import '../pieces/white_king.dart';
import '../pieces/white_knight.dart';
import '../pieces/white_pawn.dart';
import '../pieces/white_queen.dart';
import '../pieces/white_rook.dart';
import 'move.dart';
import 'square.dart';

typedef Position = List<List<Piece?>>;
typedef _Row = List<Piece?>;

class Board {
  final Position _position;

  static const int size = 20;

  Board() : _position = initialPosition;

  Board.fromPosition({required Position position})
      : assert(position.length == size &&
            !position.any((_Row row) => row.length != size)),
        _position = position;

  Piece? at(int row, int col) => _position[row][col];
  Piece? atSquare(Square square) => at(square.row, square.col);

  void move(Square from, Square to) {
    _position[to.row][to.col] = _position[from.row][from.col];
    _position[from.row][from.col] = null;
  }

  bool safeMove(Square from, Square to) {
    if (atSquare(from) == null) return false;
    move(from, to);
    return true;
  }

  void undoMove(Move move) {
    _position[move.from.row][move.from.col] =
        _position[move.to.row][move.to.col];
    _position[move.to.row][move.to.col] = move.pieceOnLandingSquare;
  }

  bool safeUndoMove(Move move) {
    if (atSquare(move.from) != null) return false;
    undoMove(move);
    return true;
  }

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

  @visibleForTesting
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

  @visibleForTesting
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
