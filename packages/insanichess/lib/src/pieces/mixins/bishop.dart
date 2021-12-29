import '../../board/board.dart';
import '../../board/move.dart';
import '../../board/square.dart';
import '../definitions/piece.dart';

mixin Bishop on Piece {
  @override
  List<Move> getPossibleMovesFromSquareOnBoard(
    Square square,
    Board board,
  ) {
    final List<Move> possibleMoves = <Move>[];

    if (isWhite) {
      int offset = 1;

      // NE
      while (square.row + offset < Board.size &&
          square.col + offset < Board.size &&
          board.at(square.row + offset, square.col + offset) == null) {
        possibleMoves.add(Move(
          square,
          Square(square.row + offset, square.col + offset),
        ));
        offset++;
      }
      if (square.row + offset < Board.size &&
          square.col + offset < Board.size &&
          (board.at(square.row + offset, square.col + offset)?.isBlack ??
              false)) {
        possibleMoves.add(Move(
          square,
          Square(square.row + offset, square.col + offset),
        ));
      }

      // SE
      offset = 1;
      while (square.row - offset >= 0 &&
          square.col + offset < Board.size &&
          board.at(square.row - offset, square.col + offset) == null) {
        possibleMoves.add(Move(
          square,
          Square(square.row - offset, square.col + offset),
        ));
        offset++;
      }
      if (square.row - offset >= 0 &&
          square.col + offset < Board.size &&
          (board.at(square.row - offset, square.col + offset)?.isBlack ??
              false)) {
        possibleMoves.add(Move(
          square,
          Square(square.row - offset, square.col + offset),
        ));
      }

      // SW
      offset = 1;
      while (square.row - offset >= 0 &&
          square.col - offset >= 0 &&
          board.at(square.row - offset, square.col - offset) == null) {
        possibleMoves.add(Move(
          square,
          Square(square.row - offset, square.col - offset),
        ));
        offset++;
      }
      if (square.row - offset >= 0 &&
          square.col - offset >= 0 &&
          (board.at(square.row - offset, square.col - offset)?.isBlack ??
              false)) {
        possibleMoves.add(Move(
          square,
          Square(square.row - offset, square.col - offset),
        ));
      }

      // NW
      offset = 1;
      while (square.row + offset < Board.size &&
          square.col - offset >= 0 &&
          board.at(square.row + offset, square.col - offset) == null) {
        possibleMoves.add(Move(
          square,
          Square(square.row + offset, square.col - offset),
        ));
        offset++;
      }
      if (square.row + offset < Board.size &&
          square.col - offset >= 0 &&
          (board.at(square.row + offset, square.col - offset)?.isBlack ??
              false)) {
        possibleMoves.add(Move(
          square,
          Square(square.row + offset, square.col - offset),
        ));
      }
    } else {
      int offset = 1;

      // NE
      while (square.row + offset < Board.size &&
          square.col + offset < Board.size &&
          board.at(square.row + offset, square.col + offset) == null) {
        possibleMoves.add(Move(
          square,
          Square(square.row + offset, square.col + offset),
        ));
        offset++;
      }
      if (square.row + offset < Board.size &&
          square.col + offset < Board.size &&
          (board.at(square.row + offset, square.col + offset)?.isWhite ??
              false)) {
        possibleMoves.add(Move(
          square,
          Square(square.row + offset, square.col + offset),
        ));
      }

      // SE
      offset = 1;
      while (square.row - offset >= 0 &&
          square.col + offset < Board.size &&
          board.at(square.row - offset, square.col + offset) == null) {
        possibleMoves.add(Move(
          square,
          Square(square.row - offset, square.col + offset),
        ));
        offset++;
      }
      if (square.row - offset >= 0 &&
          square.col + offset < Board.size &&
          (board.at(square.row - offset, square.col + offset)?.isWhite ??
              false)) {
        possibleMoves.add(Move(
          square,
          Square(square.row - offset, square.col + offset),
        ));
      }

      // SW
      offset = 1;
      while (square.row - offset >= 0 &&
          square.col - offset >= 0 &&
          board.at(square.row - offset, square.col - offset) == null) {
        possibleMoves.add(Move(
          square,
          Square(square.row - offset, square.col - offset),
        ));
        offset++;
      }
      if (square.row - offset >= 0 &&
          square.col - offset >= 0 &&
          (board.at(square.row - offset, square.col - offset)?.isWhite ??
              false)) {
        possibleMoves.add(Move(
          square,
          Square(square.row - offset, square.col - offset),
        ));
      }

      // NW
      offset = 1;
      while (square.row + offset < Board.size &&
          square.col - offset >= 0 &&
          board.at(square.row + offset, square.col - offset) == null) {
        possibleMoves.add(Move(
          square,
          Square(square.row + offset, square.col - offset),
        ));
        offset++;
      }
      if (square.row + offset < Board.size &&
          square.col - offset >= 0 &&
          (board.at(square.row + offset, square.col - offset)?.isWhite ??
              false)) {
        possibleMoves.add(Move(
          square,
          Square(square.row + offset, square.col - offset),
        ));
      }
    }

    return possibleMoves;
  }
}
