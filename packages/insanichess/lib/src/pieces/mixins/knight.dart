import '../../board/board.dart';
import '../../board/move.dart';
import '../../board/square.dart';
import '../definitions/piece.dart';

mixin Knight on Piece {
  @override
  List<Move> getPossibleMovesFromSquareOnBoard(
    Square square,
    Board board,
  ) {
    return isWhite
        ? <Move>[
            // N
            if (square.row + 2 < Board.size) ...[
              // E
              if (square.col - 1 >= 0 &&
                  !(board.at(square.row + 2, square.col - 1)?.isWhite ?? false))
                Move(square, Square(square.row + 2, square.col - 1)),
              // W
              if (square.col + 1 < Board.size &&
                  !(board.at(square.row + 2, square.col + 1)?.isWhite ?? false))
                Move(square, Square(square.row + 2, square.col + 1)),
            ],
            // E
            if (square.col + 2 < Board.size) ...[
              // S
              if (square.row - 1 >= 0 &&
                  !(board.at(square.row - 1, square.col + 2)?.isWhite ?? false))
                Move(square, Square(square.row - 1, square.col + 2)),
              // N
              if (square.row + 1 < Board.size &&
                  !(board.at(square.row + 1, square.col + 2)?.isWhite ?? false))
                Move(square, Square(square.row + 1, square.col + 2)),
            ],
            // S
            if (square.row - 2 >= 0) ...[
              // E
              if (square.col - 1 >= 0 &&
                  !(board.at(square.row - 2, square.col - 1)?.isWhite ?? false))
                Move(square, Square(square.row - 2, square.col - 1)),
              // W
              if (square.col + 1 < Board.size &&
                  !(board.at(square.row - 2, square.col + 1)?.isWhite ?? false))
                Move(square, Square(square.row - 2, square.col + 1)),
            ],
            // W
            if (square.col - 2 >= 0) ...[
              // S
              if (square.row - 1 >= 0 &&
                  !(board.at(square.row - 1, square.col - 2)?.isWhite ?? false))
                Move(square, Square(square.row - 1, square.col - 2)),
              // N
              if (square.row + 1 < Board.size &&
                  !(board.at(square.row + 1, square.col - 2)?.isWhite ?? false))
                Move(square, Square(square.row + 1, square.col - 2)),
            ],
          ]
        : <Move>[
            // N
            if (square.row + 2 < Board.size) ...[
              // E
              if (square.col - 1 >= 0 &&
                  !(board.at(square.row + 2, square.col - 1)?.isBlack ?? false))
                Move(square, Square(square.row + 2, square.col - 1)),
              // W
              if (square.col + 1 < Board.size &&
                  !(board.at(square.row + 2, square.col + 1)?.isBlack ?? false))
                Move(square, Square(square.row + 2, square.col + 1)),
            ],
            // E
            if (square.col + 2 < Board.size) ...[
              // S
              if (square.row - 1 >= 0 &&
                  !(board.at(square.row - 1, square.col + 2)?.isBlack ?? false))
                Move(square, Square(square.row - 1, square.col + 2)),
              // N
              if (square.row + 1 < Board.size &&
                  !(board.at(square.row + 1, square.col + 2)?.isBlack ?? false))
                Move(square, Square(square.row + 1, square.col + 2)),
            ],
            // S
            if (square.row - 2 < Board.size) ...[
              // E
              if (square.col - 1 >= 0 &&
                  !(board.at(square.row - 2, square.col - 1)?.isBlack ?? false))
                Move(square, Square(square.row - 2, square.col - 1)),
              // W
              if (square.col + 1 < Board.size &&
                  !(board.at(square.row - 2, square.col + 1)?.isBlack ?? false))
                Move(square, Square(square.row - 2, square.col + 1)),
            ],
            // W
            if (square.col - 2 >= 0) ...[
              // S
              if (square.row - 1 >= 0 &&
                  !(board.at(square.row - 1, square.col - 2)?.isBlack ?? false))
                Move(square, Square(square.row - 1, square.col - 2)),
              // N
              if (square.row + 1 < Board.size &&
                  !(board.at(square.row + 1, square.col - 2)?.isBlack ?? false))
                Move(square, Square(square.row + 1, square.col - 2)),
            ],
          ];
  }
}
