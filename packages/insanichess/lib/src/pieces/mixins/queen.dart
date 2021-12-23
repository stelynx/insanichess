import '../../../insanichess.dart';
import '../../board/board.dart';
import '../../board/move.dart';
import '../../board/square.dart';

mixin Queen on Piece {
  @override
  List<Move> getPossibleMovesFromSquareOnBoard(
    Square square,
    Board board,
  ) {
    return isWhite
        ? (const WhiteBishop().getPossibleMovesFromSquareOnBoard(square, board)
          ..addAll(const WhiteRook()
              .getPossibleMovesFromSquareOnBoard(square, board)))
        : const BlackBishop().getPossibleMovesFromSquareOnBoard(square, board)
      ..addAll(
          const BlackRook().getPossibleMovesFromSquareOnBoard(square, board));
  }
}
