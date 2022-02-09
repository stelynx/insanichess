import '../board/board.dart';
import '../board/move.dart';
import '../board/square.dart';
import '../pieces/black_king.dart';
import '../pieces/definitions/piece_color.dart';
import '../pieces/mixins/king.dart';
import 'game_history.dart';
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
        _gameStatus = GameStatus.notStarted {
    _calculateLegalMoves();
  }

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
        _gameStatus = status ?? GameStatus.notStarted {
    _calculateLegalMoves();
  }

  /// The `Board` of this game.
  final Board _board;

  /// The `GameHistory` of this game, containing played moves.
  final GameHistory _gameHistory;

  /// The status of the game.
  ///
  /// Status can only be updated from within this class.
  GameStatus _gameStatus;

  /// Contains the list of legal moves in current position.
  late List<Move> _legalMoves;

  /// Performs a move [m] on the board and updates [_gameStatus].
  ///
  /// Returns the `PlayedMove` if game is not over, otherwise `null`. It also
  /// sets the current `GameStatus` to `GameStatus.playing` and if the `King`
  /// was captured, it sets it to either `GameStatus.whiteCheckmated` or
  /// `GameStatus.blackCheckmated`, depending on what color is the captured
  /// `King`.
  PlayedMove? move(Move m) {
    if (isGameOver ||
        board.at(m.from.row, m.from.col)?.color != playerOnTurn ||
        !_legalMoves.contains(m)) return null;

    final PlayedMove? move = _board.safeMove(m);
    if (move == null) return null;

    _gameStatus = GameStatus.playing;
    if (move.pieceOnLandingSquare is King) {
      _gameStatus = move.pieceOnLandingSquare is BlackKing
          ? GameStatus.whiteCheckmated
          : GameStatus.blackCheckmated;
    }
    _gameHistory.add(move);
    _calculateLegalMoves();
    return move;
  }

  /// Undoes the last move.
  ///
  /// Returns the last move if undo is successful, otherwise `null`.
  PlayedMove? undo() {
    if (!canUndo) return null;

    while (canGoForward) {
      if (_board.safeMove(_gameHistory.forward()) == null) return null;
    }
    final PlayedMove lastMove = _gameHistory.undo();
    if (_board.safeUndoMove(lastMove)) {
      _calculateLegalMoves();
      return lastMove;
    }

    _gameHistory.add(lastMove);
    return null;
  }

  /// Moves one move forward in the [_gameHistory].
  ///
  /// Returns the next move from future moves if successful, otherwise `null`.
  PlayedMove? forward() {
    if (!canGoForward) return null;

    final PlayedMove nextMove = _gameHistory.forward();
    if (_board.safeMove(nextMove) != null) return nextMove;

    _gameHistory.backward();
    return null;
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
    if (!canGoBackward) return null;

    final PlayedMove lastMove = _gameHistory.backward();
    if (_board.safeUndoMove(lastMove)) return lastMove;

    _gameHistory.forward();
    return null;
  }

  /// Sets the current status to [GameStatus.draw].
  void draw() => _gameStatus = GameStatus.draw;

  /// Sets the current status to [GameStatus.whiteResigned].
  void whiteResigned() => _gameStatus = GameStatus.whiteResigned;

  /// Sets the current status to [GameStatus.blackResigned].
  void blackResigned() => _gameStatus = GameStatus.blackResigned;

  /// Sets the current status to [GameStatus.whiteFlagged] or
  /// [GameStatus.blackFlagged], depending on who the [player] is.
  ///
  /// If [player] is left `null`, the current [playerOnTurn] is marked as
  /// flagged. This is valuable for the clients to actually set the value they
  /// received in the game event from server instead of relying on their
  /// internal value that might not be the same as the one on server.
  void flagged([PieceColor? player]) =>
      _gameStatus = (player ?? playerOnTurn) == PieceColor.white
          ? GameStatus.whiteFlagged
          : GameStatus.blackFlagged;

  /// Returns the current status of the game.
  GameStatus get status => _gameStatus;

  /// Returns `true` if the game is currently in progress.
  bool get inProgress => _gameStatus == GameStatus.playing;

  /// Returns `true` if the game was won by white.
  bool get whiteWon =>
      _gameStatus == GameStatus.whiteCheckmated ||
      _gameStatus == GameStatus.blackFlagged ||
      _gameStatus == GameStatus.blackResigned;

  /// Returns `true` if the game was won by black.
  bool get blackWon =>
      _gameStatus == GameStatus.blackCheckmated ||
      _gameStatus == GameStatus.whiteFlagged ||
      _gameStatus == GameStatus.whiteResigned;

  /// Returns whether the game is over or not.
  bool get isGameOver => _gameStatus == GameStatus.draw || blackWon || whiteWon;

  /// Is there is a move that can be undone?
  bool get canUndo => _gameHistory.length > 0 && !isGameOver;

  /// Is there a future move?
  bool get canGoForward => _gameHistory.futureMoves.isNotEmpty;

  /// Is there a move in the past?
  bool get canGoBackward => _gameHistory.moves.isNotEmpty;

  List<Move> get legalMoves => _legalMoves;

  /// Returns moves played until current position.
  List<PlayedMove> get movesPlayed => _gameHistory.moves;

  /// Returns moves that are in the future. That means they were played but
  /// player went [backward] to explore move history.
  List<PlayedMove> get movesFromFuture => _gameHistory.futureMoves;

  /// Returns the current [_board].
  Board get board => _board;

  /// Returns the color of the [playerOnTurn].
  PieceColor get playerOnTurn =>
      _gameHistory.length % 2 == 0 ? PieceColor.white : PieceColor.black;

  /// Calculate all legal moves in current position for player on turn.
  ///
  /// All possible moves are legal.
  void _calculateLegalMoves() {
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

    _legalMoves = possibleMoves;
  }
}
