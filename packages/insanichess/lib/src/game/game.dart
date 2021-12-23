import '../../insanichess.dart';
import '../board/board.dart';
import 'game_status.dart';

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
        _gameHistory = GameHistory(),
        _gameStatus = GameStatus.notStarted;

  /// Creates new `Game` object from given [position], [gameHistory], and
  /// [status].
  ///
  /// Parameter [gameHistory] is optional and it defaults to empty history.
  /// Parameter [status] is optional and it defaults to `GameStatus.notStarted`.
  Game.fromPosition({
    required Position position,
    GameHistory? gameHistory,
    GameStatus? status,
  })  : _board = Board.fromPosition(position: position),
        _gameHistory = gameHistory ?? GameHistory(),
        _gameStatus = status ?? GameStatus.notStarted;

  /// The `Board` of this game.
  final Board _board;

  /// The `GameHistory` of this game, containing played moves.
  final GameHistory _gameHistory;

  /// The status of the game.
  ///
  /// Status can only be updated from within this class.
  final GameStatus _gameStatus;

  /// Performs a move [m] on the board.
  ///
  /// Returns the played [PlayedMove] if successful, otherwise `null`.
  PlayedMove? move(Move m) {
    final PlayedMove? move = _board.safeMove(m);
    if (move != null) {
      _gameHistory.add(move);
      return move;
    }
  }

  /// Undoes the last move.
  ///
  /// Returns the last move if undo is successful, otherwise `null`.
  PlayedMove? undo() {
    final PlayedMove lastMove = _gameHistory.undo();
    if (_board.safeUndoMove(lastMove)) return lastMove;

    _gameHistory.futureMoves.add(lastMove);
  }

  /// Moves one move forward in the [_gameHistory].
  ///
  /// Returns the next move from future moves if successful, otherwise `null`.
  PlayedMove? forward() {
    final PlayedMove nextMove = _gameHistory.forward();
    if (_board.safeMove(nextMove) != null) return nextMove;

    _gameHistory.backward();
  }

  /// Moves one move backward in the [_gameHistory].
  ///
  /// Difference between [backward] and [undo] is that [undo] cannot be "undone"
  /// but [backward] can be undone using [forward]. In other words, [backward]
  /// does not destroy [_gameHistory].
  ///
  /// Method [backward] can be used in combination with [forward] to explore
  /// [_gameHistory] without deleting any of the moves.
  PlayedMove? backward() {
    final PlayedMove lastMove = _gameHistory.backward();
    if (_board.safeUndoMove(lastMove)) return lastMove;

    _gameHistory.forward();
  }

  /// Calculate all legal moves in current position for player on turn.
  ///
  /// All possible moves are legal.
  List<Move> getLegalMoves() {
    final List<Move> possibleMoves = <Move>[];

    if (playerOnTurn == PieceColor.white) {
      for (int row = 0; row < Board.size; row++) {
        for (int col = 0; col < Board.size; col++) {
          if (board.at(row, col)?.isWhite ?? false) {
            possibleMoves.addAll(board
                .at(row, col)!
                .getPossibleMovesFromSquareOnBoard(Square(row, col), board));
          }
        }
      }
    } else {
      for (int row = 0; row < Board.size; row++) {
        for (int col = 0; col < Board.size; col++) {
          if (board.at(row, col)?.isBlack ?? false) {
            possibleMoves.addAll(board
                .at(row, col)!
                .getPossibleMovesFromSquareOnBoard(Square(row, col), board));
          }
        }
      }
    }

    return possibleMoves;
  }

  /// Returns the current status of the game.
  GameStatus get status => _gameStatus;

  /// Returns moves played until current position.
  List<PlayedMove> get movesPlayed => _gameHistory.moves;

  /// Returns moves that are in the future. That means they were played but
  /// player went [backward] to explore move history.
  List<PlayedMove> get movesFromFuture => _gameHistory.futureMoves;

  /// Returns the current [_board].
  Board get board => _board;

  /// Returns the color of the [playerOnTurn].
  PieceColor get playerOnTurn =>
      _gameHistory.length % 2 == 0 ? PieceColor.white : PieceColor.white;
}
