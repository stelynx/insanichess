import 'package:insanichess/insanichess.dart' as insanichess;

import 'models/user/player.dart';
import 'time_control.dart';

/// Contains all information about the game.
///
/// Apart from basic game rules, this class adds information that is usable both
/// to client and server in order to be able to play a game of Insanichess.
class InsanichessGame extends insanichess.Game {
  /// The id of the game.
  final String id;

  /// Information for player with white pieces.
  final InsanichessPlayer whitePlayer;

  /// Information for player with black pieces.
  final InsanichessPlayer blackPlayer;

  /// Time control for the game.
  final InsanichessTimeControl timeControl;

  final List<Duration> timesSpentPerMove;

  /// Remaining playing time for white.
  Duration remainingTimeWhite;

  /// Remaining playing time for black.
  Duration remainingTimeBlack;

  /// Constructs a fresh game with initial position.
  InsanichessGame({
    required this.id,
    required this.whitePlayer,
    required this.blackPlayer,
    required this.timeControl,
  })  : remainingTimeWhite = timeControl.initialTime,
        remainingTimeBlack = timeControl.initialTime,
        timesSpentPerMove = <Duration>[],
        super();

  /// Constructs a game from given [position] and [gameHistory] with option to
  /// change [remainingTimeWhite] and [remainingTimeBlack].
  InsanichessGame.fromPosition({
    required this.id,
    required this.whitePlayer,
    required this.blackPlayer,
    required this.timeControl,
    List<Duration>? timesSpentPerMove,
    Duration? remainingTimeWhite,
    Duration? remainingTimeBlack,
    required insanichess.Position position,
    insanichess.GameHistory? gameHistory,
  })  : remainingTimeWhite = remainingTimeWhite ?? timeControl.initialTime,
        remainingTimeBlack = remainingTimeBlack ?? timeControl.initialTime,
        timesSpentPerMove = timesSpentPerMove ?? <Duration>[],
        super.fromPosition(position: position, gameHistory: gameHistory);

  /// Returns new `InsanichessGame` object from ICString representation [s].
  factory InsanichessGame.fromICString(String s) {
    final List<String> lines = s.split('\n');

    final List<String> timeControlStringList = lines[2].split(' ');
    final List<String> remainingTimeStringList = lines[3].split(' ');
    final List<String> timesPerMoveStringList = lines[4].split(' ');

    final InsanichessGame game = InsanichessGame.fromPosition(
      id: lines[0],
      whitePlayer: const InsanichessPlayer.testWhite(),
      blackPlayer: const InsanichessPlayer.testBlack(),
      timeControl: InsanichessTimeControl(
        initialTime: Duration(seconds: int.parse(timeControlStringList.first)),
        incrementPerMove:
            Duration(seconds: int.parse(timeControlStringList.last)),
      ),
      timesSpentPerMove: timesPerMoveStringList
          .map<Duration>((String s) => Duration(milliseconds: int.parse(s)))
          .toList(),
      remainingTimeWhite:
          Duration(milliseconds: int.parse(remainingTimeStringList.first)),
      remainingTimeBlack:
          Duration(milliseconds: int.parse(remainingTimeStringList.last)),
      position: insanichess.Board.initialPosition,
    );

    for (int i = 6; i < lines.length; i++) {
      final List<String> splittedLine = lines[i].trim().split(' ');
      if (splittedLine.first.isEmpty) break;

      game.move(insanichess.Move.fromICString(splittedLine.first));
      if (splittedLine.length > 1) {
        game.move(insanichess.Move.fromICString(splittedLine.last));
      }
    }

    // If the status was not automatically resolved, the status is therefore
    // a draw.
    if (game.inProgress) {
      game.draw();
    }

    return game;
  }

  /// Creates a `String` representation of a [game]. This representation contains
  /// in each line a pair of moves of white and black player, separated by `' '`
  /// character and game metadata at the start.
  String toICString() {
    String icString = '';

    icString += '$id\n';
    icString += '${whitePlayer.id} ${blackPlayer.id}\n';
    icString +=
        '${timeControl.initialTime.inSeconds} ${timeControl.incrementPerMove.inSeconds}\n';
    icString +=
        '${remainingTimeWhite.inMilliseconds} ${remainingTimeBlack.inMilliseconds}\n';
    if (timesSpentPerMove.isNotEmpty) {
      icString += '${timesSpentPerMove.first.inMilliseconds}';
      for (int i = 1; i < timesSpentPerMove.length; i++) {
        icString += ' ${timesSpentPerMove[i].inMilliseconds}';
      }
    }
    icString += '\n';
    icString += board.getFenRepresentation() + '\n';

    int moveIndex = 0;
    for (; moveIndex + 1 < movesPlayed.length; moveIndex += 2) {
      icString +=
          '${movesPlayed[moveIndex].toICString()} ${movesPlayed[moveIndex + 1].toICString()}\n';
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
          '${movesPlayed[futureMoveIndex].toICString()} ${movesPlayed[futureMoveIndex - 1].toICString()}\n';
    }
    if (futureMoveIndex == 0) {
      icString += '${movesPlayed[futureMoveIndex].toICString()} ';
    }

    return icString;
  }

  /// Two `InsanichessGame`s are equal if they have the same [id].
  @override
  bool operator ==(Object? other) {
    if (other is! InsanichessGame) return false;
    return id == other.id;
  }

  /// [hashCode] for `InsanichessGame` is simply [id.hashCode].
  @override
  int get hashCode => id.hashCode;
}
