import '../../board/board.dart';
import '../../board/move.dart';
import '../../board/square.dart';
import '../black_bishop.dart';
import '../black_rook.dart';
import '../definitions/piece.dart';
import '../white_bishop.dart';
import '../white_rook.dart';

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
