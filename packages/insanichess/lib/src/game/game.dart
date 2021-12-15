import 'package:insanichess/insanichess.dart';
import 'package:insanichess/src/board/board.dart';

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
    final Move lastMove = _gameHistory.pop();
    return _board.safeUndoMove(lastMove) ? lastMove : null;
  }
}
