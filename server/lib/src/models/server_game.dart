import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';

/// Extends [InsanichessGame] with data that a server needs for bookkeeping.
class ServerGame extends InsanichessGame {
  /// Undo is allowed in this game if both players have set the "allow undo"
  /// setting to `true` in their [InsanichessLiveGameSettings].
  final bool undoAllowed;

  /// The color of the player that offered draw. If there is no player currently
  /// offering a draw, this field is `null`.
  insanichess.PieceColor? playerOfferedDraw;

  /// Constructs new [ServerGame] object.
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
  ServerGame({
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
}
