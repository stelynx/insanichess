import '../../../insanichess.dart';
import '../../board/board.dart';
import '../../board/move.dart';
import '../../board/square.dart';

mixin King on Piece {
  @override
  List<Move> getPossibleMovesFromSquareInPosition(
    Square square,
    Position position,
  ) {
    return isWhite
        ? <Move>[
            // N
            if (square.row + 1 < Board.size &&
                !(position[square.row + 1][square.col]?.isWhite ?? false))
              Move(square, Square(square.row + 1, square.col)),
            // NE
            if (square.row + 1 < Board.size &&
                square.col + 1 < Board.size &&
                !(position[square.row + 1][square.col + 1]?.isWhite ?? false))
              Move(square, Square(square.row + 1, square.col + 1)),
            // E
            if (square.col + 1 < Board.size &&
                !(position[square.row][square.col + 1]?.isWhite ?? false))
              Move(square, Square(square.row, square.col + 1)),
            // SE
            if (square.row - 1 >= 0 &&
                square.col + 1 < Board.size &&
                !(position[square.row - 1][square.col + 1]?.isWhite ?? false))
              Move(square, Square(square.row - 1, square.col - 1)),
            // S
            if (square.row - 1 >= 0 &&
                !(position[square.row - 1][square.col]?.isWhite ?? false))
              Move(square, Square(square.row - 1, square.col)),
            // SW
            if (square.row - 1 >= 0 &&
                square.col - 1 >= 0 &&
                !(position[square.row - 1][square.col - 1]?.isWhite ?? false))
              Move(square, Square(square.row - 1, square.col - 1)),
            // W
            if (square.col - 1 >= 0 &&
                !(position[square.row][square.col - 1]?.isWhite ?? false))
              Move(square, Square(square.row, square.col - 1)),
            // NW
            if (square.row + 1 < Board.size &&
                square.col - 1 >= 0 &&
                !(position[square.row + 1][square.col - 1]?.isWhite ?? false))
              Move(square, Square(square.row + 1, square.col)),
          ]
        : <Move>[
            // N
            if (square.row + 1 < Board.size &&
                !(position[square.row + 1][square.col]?.isBlack ?? false))
              Move(square, Square(square.row + 1, square.col)),
            // NE
            if (square.row + 1 < Board.size &&
                square.col + 1 < Board.size &&
                !(position[square.row + 1][square.col + 1]?.isBlack ?? false))
              Move(square, Square(square.row + 1, square.col + 1)),
            // E
            if (square.col + 1 < Board.size &&
                !(position[square.row][square.col + 1]?.isBlack ?? false))
              Move(square, Square(square.row, square.col + 1)),
            // SE
            if (square.row - 1 >= 0 &&
                square.col + 1 < Board.size &&
                !(position[square.row - 1][square.col + 1]?.isBlack ?? false))
              Move(square, Square(square.row - 1, square.col - 1)),
            // S
            if (square.row - 1 >= 0 &&
                !(position[square.row - 1][square.col]?.isBlack ?? false))
              Move(square, Square(square.row - 1, square.col)),
            // SW
            if (square.row - 1 >= 0 &&
                square.col - 1 >= 0 &&
                !(position[square.row - 1][square.col - 1]?.isBlack ?? false))
              Move(square, Square(square.row - 1, square.col - 1)),
            // W
            if (square.col - 1 >= 0 &&
                !(position[square.row][square.col - 1]?.isBlack ?? false))
              Move(square, Square(square.row, square.col - 1)),
            // NW
            if (square.row + 1 < Board.size &&
                square.col - 1 >= 0 &&
                !(position[square.row + 1][square.col - 1]?.isBlack ?? false))
              Move(square, Square(square.row + 1, square.col)),
          ];
  }
}
