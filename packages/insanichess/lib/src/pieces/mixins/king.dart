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
    return [];
  }
}
