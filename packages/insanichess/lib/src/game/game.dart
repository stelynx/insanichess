import '../../insanichess.dart';
import '../board/board.dart';

class Game {
  Game()
      : _board = Board(),
        _gameHistory = GameHistory();

  Game.fromPosition({required Position position, GameHistory? gameHistory})
      : _board = Board.fromPosition(position: position),
        _gameHistory = gameHistory ?? GameHistory();

  final Board _board;

  final GameHistory _gameHistory;

  Move? move(Square from, Square to) {
    final Move move = Move(from, to, _board.atSquare(to));
    if (_board.safeMove(from, to)) {
      _gameHistory.add(move);
      return move;
    }
  }

  Move? undo() {
    final Move lastMove = _gameHistory.undo();
    return _board.safeUndoMove(lastMove) ? lastMove : null;
  }

  Move? forward() {
    final Move nextMove = _gameHistory.forward();
    return _board.safeMove(nextMove.from, nextMove.to) ? nextMove : null;
  }

  Move? backward() {
    final Move lastMove = _gameHistory.backward();
    return _board.safeUndoMove(lastMove) ? lastMove : null;
  }

  List<Move> get movesPlayed => _gameHistory.moves;
  List<Move> get movesFromFuture => _gameHistory.futureMoves;
  Board get board => _board;
}
