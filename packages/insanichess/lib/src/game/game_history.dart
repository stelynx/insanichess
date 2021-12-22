import '../board/move.dart';

/// Holds data about moves played.
class GameHistory {
  /// Contains all moves played until current position on the board.
  final List<Move> moves;

  /// Contains moves from the future, those that were popped using [backward].
  final List<Move> futureMoves;

  /// Constructs new `GameHistory` object with no moves played.
  GameHistory()
      : moves = <Move>[],
        futureMoves = <Move>[];

  /// Constructs new `GameHistory` object with [moves] already played and with
  /// potential [futureMoves].
  GameHistory.withMoves({required this.moves, List<Move>? futureMoves})
      : futureMoves = futureMoves ?? <Move>[];

  /// Undoes and returns the last move played. This operation cannot be undone!
  Move undo() => moves.removeLast();

  /// Adds a [move] to the list of played [moves].
  void add(Move move) => moves.add(move);

  /// Returns the number of moves played by both players.
  int get length => moves.length + futureMoves.length;

  /// Goes one step back through the history and returns the previous move.
  Move backward() {
    final Move move = moves.removeLast();
    futureMoves.add(move);
    return move;
  }

  /// Goes one step forth through the history and returns the next move.
  Move forward() {
    final Move move = futureMoves.removeLast();
    moves.add(move);
    return move;
  }
}
