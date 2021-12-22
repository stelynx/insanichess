import 'package:insanichess/insanichess.dart' as insanichess;

import 'player.dart';
import 'time_control.dart';

/// Contains all information about the game.
///
/// Apart from basic game rules, this class adds information that is usable both
/// to client and server in order to be able to play a game of Insanichess.
class InsanichessGame extends insanichess.Game {
  /// Information for player with white pieces.
  final InsanichessPlayer whitePlayer;

  /// Information for player with black pieces.
  final InsanichessPlayer blackPlayer;

  /// Time control for the game.
  final InsanichessTimeControl timeControl;

  /// Remaining playing time for white.
  Duration remainingTimeWhite;

  /// Remaining playing time for black.
  Duration remainingTimeBlack;

  /// Constructs a fresh game with initial position.
  InsanichessGame({
    required this.whitePlayer,
    required this.blackPlayer,
    required this.timeControl,
  })  : remainingTimeWhite = timeControl.initialTime,
        remainingTimeBlack = timeControl.initialTime,
        super();

  /// Constructs a game from given [position] and [gameHistory] with option to
  /// change [remainingTimeWhite] and [remainingTimeBlack].
  InsanichessGame.fromPosition({
    required this.whitePlayer,
    required this.blackPlayer,
    required this.timeControl,
    Duration? remainingTimeWhite,
    Duration? remainingTimeBlack,
    required insanichess.Position position,
    insanichess.GameHistory? gameHistory,
  })  : remainingTimeWhite = remainingTimeWhite ?? timeControl.initialTime,
        remainingTimeBlack = remainingTimeBlack ?? timeControl.initialTime,
        super.fromPosition(position: position, gameHistory: gameHistory);

  /// Creates a `String` representation of a [game]. This representation contains
  /// in each line a pair of moves of white and black player, separated by `\t`
  /// character.
  String toICString() {
    String icString = '';
    int moveIndex = 0;
    for (; moveIndex + 1 < movesPlayed.length; moveIndex += 2) {
      icString +=
          '${movesPlayed[moveIndex].toICString()}\t${movesPlayed[moveIndex + 1].toICString()}\n';
    }

    int futureMoveIndex = movesFromFuture.length - 1;

    if (moveIndex < movesPlayed.length) {
      // moveIndex == game.movesPlayed.length - 1
      icString += '${movesPlayed[moveIndex].toICString()}\t';
      if (futureMoveIndex != -1) {
        icString += '${movesFromFuture[futureMoveIndex].toICString()}\n';
        futureMoveIndex--;
      }
    }

    for (; futureMoveIndex - 1 >= 0; futureMoveIndex -= 2) {
      icString +=
          '${movesPlayed[futureMoveIndex].toICString()}\t${movesPlayed[futureMoveIndex - 1].toICString()}\n';
    }
    if (futureMoveIndex == 0) {
      icString += '${movesPlayed[futureMoveIndex].toICString()}\t';
    }

    return icString;
  }
}
