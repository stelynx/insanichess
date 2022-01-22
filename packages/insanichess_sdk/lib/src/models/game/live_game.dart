import 'package:insanichess/insanichess.dart' as insanichess;

import '../../time_control.dart';
import '../user/player.dart';
import 'game.dart';

/// Extends [InsanichessGame] with data that a server needs for bookkeeping and
/// player's client needs to update UI accordingly.
///
/// This extension adds capabilities to [InsanichessGame] that are important
/// only for games currently being played.
class InsanichessLiveGame extends InsanichessGame {
  /// Undo is allowed in this game if both players have set the "allow undo"
  /// setting to `true` in their [InsanichessLiveGameSettings].
  final bool undoAllowed;

  /// The color of the player that offered draw. If there is no player currently
  /// offering a draw, this field is `null`.
  ///
  /// This field should only be used internally by server for bookkeeping.
  insanichess.PieceColor? playerOfferedDraw;

  /// The color of the player that offered draw. If there is no player currently
  /// requesting undo, this field is `null`.
  ///
  /// This field should only be used internally by server for bookkeeping.
  insanichess.PieceColor? playerRequestedUndo;

  /// The time when the last move has been played. Comparing this field to
  /// current time the time a player needed for a move is calculated.
  ///
  /// Initially, this field is set to `null` and should never be set to null
  /// again.
  ///
  /// This field is used internally by server for bookkeeping.
  DateTime? timeOfLastMove;

  /// Constructs new [InsanichessLiveGame] object.
  ///
  /// Field [playerOfferedDraw] is set to `null` at the start and can only be
  /// changed when the game is in progress.
  ///
  /// Field [undoAllowed] indicates whether both [whitePlayer] and [blackPlayer]
  /// approve of allowing undo requests. This field is `final` and cannot be
  /// changed during the game.
  ///
  /// Arguments [id], [whitePlayer], [blackPlayer] and [timeControl] are
  /// forwarded to [InsanichessGame] constructor.
  InsanichessLiveGame({
    required this.undoAllowed,
    required String id,
    required InsanichessPlayer whitePlayer,
    required InsanichessPlayer blackPlayer,
    required InsanichessTimeControl timeControl,
  }) : super(
          id: id,
          whitePlayer: whitePlayer,
          blackPlayer: blackPlayer,
          timeControl: timeControl,
        );

  /// Creates new [InsanichessLiveGame] from [json] representation.
  ///
  /// This object should only be transmitted to user once at the start of the
  /// game. A client that accepted the challenge should then query the server
  /// for this object. A client that is awaiting challenge accept should query
  /// for this object after it finds out that the game is accepted.
  InsanichessLiveGame.fromJson(Map<String, dynamic> json)
      : undoAllowed = json[InsanichessLiveGameJsonKey.undoAllowed],
        super.fromJson(json);

  /// Converts this object to json representation.
  ///
  /// This object should only be transmitted to user once at the start of the
  /// game. A client that accepted the challenge should then query the server
  /// for this object. A client that is awaiting challenge accept should query
  /// for this object after it finds out that the game is accepted.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessLiveGameJsonKey.undoAllowed: undoAllowed,
      ...super.toJson(),
    };
  }

  /// Performs a move on the board.
  ///
  /// This method overrides the [InsanichessGame.move]. It adds support for time
  /// tracking.
  @override
  insanichess.PlayedMove? move(insanichess.Move m) {
    final DateTime timeOfMove = DateTime.now();

    // This needs to be remembered because calling `super.move(m)` will change
    // player on turn.
    final insanichess.PieceColor playerMakingMove = playerOnTurn;

    final insanichess.PlayedMove? playedMove = super.move(m);
    if (playedMove == null) return null;

    final Duration moveDuration;
    if (timeOfLastMove == null) {
      // This only happens when white player makes his first move.
      moveDuration = Duration.zero;
    } else {
      moveDuration = timeOfMove.difference(timeOfLastMove!);
    }
    timesSpentPerMove.add(moveDuration);

    // Deduct time spent for move and add increment.
    if (playerMakingMove == insanichess.PieceColor.white) {
      remainingTimeWhite =
          remainingTimeWhite - moveDuration + timeControl.incrementPerMove;
    } else {
      remainingTimeBlack =
          remainingTimeBlack - moveDuration + timeControl.incrementPerMove;
    }

    // Set to `DateTime.now()` to ignore time spent for processing.
    timeOfLastMove = DateTime.now();
    return playedMove;
  }
}

/// Provides keys for json representations of [InsanichessLiveGame].
abstract class InsanichessLiveGameJsonKey {
  /// Key for [InsanichessLiveGame.undoAllowed].
  static const String undoAllowed = 'undo_allowed';
}
