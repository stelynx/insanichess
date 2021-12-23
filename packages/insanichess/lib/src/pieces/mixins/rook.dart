import '../../../insanichess.dart';
import '../../board/board.dart';
import '../../board/move.dart';
import '../../board/square.dart';

mixin Rook on Piece {
  @override
  List<Move> getPossibleMovesFromSquareOnBoard(
    Square square,
    Board board,
  ) {
    final List<Move> possibleMoves = <Move>[];

    if (isWhite) {
      int offset = 1;

      // N
      while (square.row + offset < Board.size &&
          board.at(square.row + offset, square.col) == null) {
        possibleMoves
            .add(Move(square, Square(square.row + offset, square.col)));
        offset++;
      }
      if (square.row + offset < Board.size &&
          (board.at(square.row + offset, square.col)?.isBlack ?? false)) {
        possibleMoves
            .add(Move(square, Square(square.row + offset, square.col)));
      }

      // E
      while (square.col + offset < Board.size &&
          board.at(square.row, square.col + offset) == null) {
        possibleMoves
            .add(Move(square, Square(square.row, square.col + offset)));
        offset++;
      }
      if (square.col + offset < Board.size &&
          (board.at(square.row, square.col + offset)?.isBlack ?? false)) {
        possibleMoves
            .add(Move(square, Square(square.row, square.col + offset)));
      }

      // S
      offset = 1;
      while (square.row - offset >= 0 &&
          board.at(square.row - offset, square.col) == null) {
        possibleMoves
            .add(Move(square, Square(square.row - offset, square.col)));
        offset++;
      }
      if (square.row - offset < Board.size &&
          (board.at(square.row - offset, square.col)?.isBlack ?? false)) {
        possibleMoves
            .add(Move(square, Square(square.row - offset, square.col)));
      }

      // W
      while (square.col - offset >= 0 &&
          board.at(square.row, square.col - offset) == null) {
        possibleMoves
            .add(Move(square, Square(square.row, square.col - offset)));
        offset++;
      }
      if (square.col - offset >= 0 &&
          (board.at(square.row, square.col - offset)?.isBlack ?? false)) {
        possibleMoves
            .add(Move(square, Square(square.row, square.col - offset)));
      }
    } else {
      int offset = 1;

      // N
      while (square.row + offset < Board.size &&
          board.at(square.row + offset, square.col) == null) {
        possibleMoves
            .add(Move(square, Square(square.row + offset, square.col)));
        offset++;
      }
      if (square.row + offset < Board.size &&
          (board.at(square.row + offset, square.col)?.isWhite ?? false)) {
        possibleMoves
            .add(Move(square, Square(square.row + offset, square.col)));
      }

      // E
      while (square.col + offset < Board.size &&
          board.at(square.row, square.col + offset) == null) {
        possibleMoves
            .add(Move(square, Square(square.row, square.col + offset)));
        offset++;
      }
      if (square.col + offset < Board.size &&
          (board.at(square.row, square.col + offset)?.isWhite ?? false)) {
        possibleMoves
            .add(Move(square, Square(square.row, square.col + offset)));
      }

      // S
      offset = 1;
      while (square.row - offset >= 0 &&
          board.at(square.row - offset, square.col) == null) {
        possibleMoves
            .add(Move(square, Square(square.row - offset, square.col)));
        offset++;
      }
      if (square.row - offset < Board.size &&
          (board.at(square.row - offset, square.col)?.isWhite ?? false)) {
        possibleMoves
            .add(Move(square, Square(square.row - offset, square.col)));
      }

      // W
      while (square.col - offset >= 0 &&
          board.at(square.row, square.col - offset) == null) {
        possibleMoves
            .add(Move(square, Square(square.row, square.col - offset)));
        offset++;
      }
      if (square.col - offset >= 0 &&
          (board.at(square.row, square.col - offset)?.isWhite ?? false)) {
        possibleMoves
            .add(Move(square, Square(square.row, square.col - offset)));
      }
    }

    return possibleMoves;
  }
}
