import '../../insanichess.dart';
import '../board/board.dart';

/// Representation of the game.
///
/// Contains all information regarding game from logic perspective. The [_board]
/// contains current position, [_gameHistory] contains move history and provides
/// option to undo move and also go back and forth between moves.
class Game {
  /// Creates new `Game` object with default initial [_board] and empty
  /// [_gameHistory].
  Game()
      : _board = Board(),
        _gameHistory = GameHistory();

  /// Creates new `Game` object from given [position] and [gameHistory].
  ///
  /// Parameter [gameHistory] is optional and it defaults to empty history.
  Game.fromPosition({required Position position, GameHistory? gameHistory})
      : _board = Board.fromPosition(position: position),
        _gameHistory = gameHistory ?? GameHistory();

  /// The `Board` of this game.
  final Board _board;

  /// The `GameHistory` of this game, containing played moves.
  final GameHistory _gameHistory;

  /// Performs a move on the board.
  ///
  /// The move is [from] and [to] `Square`.
  /// Returns the played [Move] if successful, otherwise `null`.
  Move? move(Square from, Square to) {
    final Move move = Move(from, to, _board.atSquare(to));
    if (_board.safeMove(from, to)) {
      _gameHistory.add(move);
      return move;
    }
  }

  /// Undoes the last move.
  ///
  /// Returns the last move if undo is successful, otherwise `null`.
  Move? undo() {
    final Move lastMove = _gameHistory.undo();
    return _board.safeUndoMove(lastMove) ? lastMove : null;
  }

  /// Moves one move forward in the [_gameHistory].
  ///
  /// Returns the next move from future moves if successful, otherwise `null`.
  Move? forward() {
    final Move nextMove = _gameHistory.forward();
    return _board.safeMove(nextMove.from, nextMove.to) ? nextMove : null;
  }

  /// Moves one move backward in the [_gameHistory].
  ///
  /// Difference between [backward] and [undo] is that [undo] cannot be "undone"
  /// but [backward] can be undone using [forward]. In other words, [backward]
  /// does not destroy [_gameHistory].
  ///
  /// Method [backward] can be used in combination with [forward] to explore
  /// [_gameHistory] without deleting any of the moves.
  Move? backward() {
    final Move lastMove = _gameHistory.backward();
    return _board.safeUndoMove(lastMove) ? lastMove : null;
  }

  /// Returns moves played until current position.
  List<Move> get movesPlayed => _gameHistory.moves;

  /// Returns moves that are in the future. That means they were played but
  /// player went [backward] to explore move history.
  List<Move> get movesFromFuture => _gameHistory.futureMoves;

  /// Returns the current [_board].
  Board get board => _board;
}
