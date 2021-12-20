import '../board/move.dart';

class GameHistory {
  final List<Move> moves;
  final List<Move> futureMoves;

  GameHistory()
      : moves = <Move>[],
        futureMoves = <Move>[];

  Move undo() => moves.removeLast();
  void add(Move move) => moves.add(move);
  int get length => moves.length;

  Move backward() {
    final Move move = moves.removeLast();
    futureMoves.add(move);
    return move;
  }

  Move forward() {
    final Move move = futureMoves.removeLast();
    moves.add(move);
    return move;
  }
}
