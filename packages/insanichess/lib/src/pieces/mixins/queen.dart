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
    if (isWhite) {
      final List<Move> bishopMoves =
          const WhiteBishop().getPossibleMovesFromSquareOnBoard(square, board);
      final List<Move> rookMoves =
          const WhiteRook().getPossibleMovesFromSquareOnBoard(square, board);
      bishopMoves.addAll(rookMoves);
      return bishopMoves;
    }

    final List<Move> bishopMoves =
        const BlackBishop().getPossibleMovesFromSquareOnBoard(square, board);
    final List<Move> rookMoves =
        const BlackRook().getPossibleMovesFromSquareOnBoard(square, board);
    bishopMoves.addAll(rookMoves);
    return bishopMoves;
  }
}
