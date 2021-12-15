import 'package:insanichess/src/board/move.dart';

class GameHistory {
  final List<Move> moves;

  GameHistory() : moves = <Move>[];

  Move pop() => moves.removeLast();
  void add(Move move) => moves.add(move);
  int get length => moves.length;
}
