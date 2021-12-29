import '../../../insanichess.dart';
import '../../board/board.dart';
import '../../board/move.dart';
import '../../board/square.dart';

mixin Pawn on Piece {
  @override
  List<Move> getPossibleMovesFromSquareOnBoard(
    Square square,
    Board board,
  ) {
    final int rowDiff = isWhite ? 1 : -1;

    final List<Move> possibleMoves;
    if ((isWhite && square.row == Board.size - 2) ||
        (isBlack && square.row == 1)) {
      possibleMoves = <Move>[
        if (board.at(square.row + rowDiff, square.col) == null) ...[
          Move(
            square,
            Square(square.row + rowDiff, square.col),
            isWhite ? const WhiteBishop() : const BlackBishop(),
          ),
          Move(
            square,
            Square(square.row + rowDiff, square.col),
            isWhite ? const WhiteKnight() : const BlackKnight(),
          ),
          Move(
            square,
            Square(square.row + rowDiff, square.col),
            isWhite ? const WhiteQueen() : const BlackQueen(),
          ),
          Move(
            square,
            Square(square.row + rowDiff, square.col),
            isWhite ? const WhiteRook() : const BlackRook(),
          ),
        ],
        if (square.col + 1 < Board.size &&
            ((isWhite &&
                    !(board.at(square.row + rowDiff, square.col + 1)?.isWhite ??
                        false)) ||
                (isBlack &&
                    !(board.at(square.row + rowDiff, square.col + 1)?.isBlack ??
                        false)))) ...[
          Move(
            square,
            Square(square.row + rowDiff, square.col + 1),
            isWhite ? const WhiteBishop() : const BlackBishop(),
          ),
          Move(
            square,
            Square(square.row + rowDiff, square.col + 1),
            isWhite ? const WhiteKnight() : const BlackKnight(),
          ),
          Move(
            square,
            Square(square.row + rowDiff, square.col + 1),
            isWhite ? const WhiteQueen() : const BlackQueen(),
          ),
          Move(
            square,
            Square(square.row + rowDiff, square.col + 1),
            isWhite ? const WhiteRook() : const BlackRook(),
          ),
        ],
        if (square.col - 1 < Board.size &&
            ((isWhite &&
                    !(board.at(square.row + rowDiff, square.col - 1)?.isWhite ??
                        false)) ||
                (isBlack &&
                    !(board.at(square.row + rowDiff, square.col - 1)?.isBlack ??
                        false)))) ...[
          Move(
            square,
            Square(square.row + rowDiff, square.col - 1),
            isWhite ? const WhiteBishop() : const BlackBishop(),
          ),
          Move(
            square,
            Square(square.row + rowDiff, square.col - 1),
            isWhite ? const WhiteKnight() : const BlackKnight(),
          ),
          Move(
            square,
            Square(square.row + rowDiff, square.col - 1),
            isWhite ? const WhiteQueen() : const BlackQueen(),
          ),
          Move(
            square,
            Square(square.row + rowDiff, square.col - 1),
            isWhite ? const WhiteRook() : const BlackRook(),
          ),
        ],
      ];
    } else {
      possibleMoves = <Move>[
        if (board.at(square.row + rowDiff, square.col) == null)
          Move(square, Square(square.row + rowDiff, square.col)),
        if (square.col + 1 < Board.size &&
            ((isWhite &&
                    !(board.at(square.row + rowDiff, square.col + 1)?.isWhite ??
                        false)) ||
                (isBlack &&
                    !(board.at(square.row + rowDiff, square.col + 1)?.isBlack ??
                        false))))
          Move(square, Square(square.row + rowDiff, square.col + 1)),
        if (square.col - 1 >= 0 &&
            ((isWhite &&
                    !(board.at(square.row + rowDiff, square.col - 1)?.isWhite ??
                        false)) ||
                (isBlack &&
                    !(board.at(square.row + rowDiff, square.col - 1)?.isBlack ??
                        false))))
          Move(square, Square(square.row + rowDiff, square.col - 1)),
      ];
    }

    return possibleMoves;
  }
}
