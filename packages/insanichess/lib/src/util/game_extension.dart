import '../game/game.dart';

String gameToICString(Game game) {
  String icString = '';
  int moveIndex = 0;
  for (; moveIndex + 1 < game.movesPlayed.length; moveIndex += 2) {
    icString +=
        '${game.movesPlayed[moveIndex].toICString()}\t${game.movesPlayed[moveIndex + 1].toICString()}\n';
  }

  int futureMoveIndex = game.movesFromFuture.length - 1;

  if (moveIndex < game.movesPlayed.length) {
    // moveIndex == game.movesPlayed.length - 1
    icString += '${game.movesPlayed[moveIndex].toICString()}\t';
    if (futureMoveIndex != -1) {
      icString += '${game.movesFromFuture[futureMoveIndex].toICString()}\n';
      futureMoveIndex--;
    }
  }

  for (; futureMoveIndex - 1 >= 0; futureMoveIndex -= 2) {
    icString +=
        '${game.movesPlayed[futureMoveIndex].toICString()}\t${game.movesPlayed[futureMoveIndex - 1].toICString()}\n';
  }
  if (futureMoveIndex == 0) {
    icString += '${game.movesPlayed[futureMoveIndex].toICString()}\t';
  }

  return icString;
}
