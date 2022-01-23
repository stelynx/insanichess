part of 'live_game_bloc.dart';

@immutable
class LiveGameState {
  final InsanichessLiveGame? game;
  final insanichess.PieceColor? myColor;

  final bool gameDisbanded;

  /// If a draw offer has been responded and declined, the `playerOfferedDraw`
  /// in game object will still be set to myself, becuase the requests should
  /// not be spammed. This field then indicates if a response has been received
  /// or not.
  final bool? drawOfferResponded;

  /// If an undo request has been responded and declined, `playerOfferedDraw`
  /// in game object will still be set to myself, becuase the requests should
  /// not be spammed. This field then indicates if a response has been received
  /// or not.
  final bool? undoRequestResponded;

  final bool failedToJoinTheGame;
  final bool enableZoomButton;
  final bool showZoomOutButtonOnLeft;
  final bool showLegalMoves;
  final bool autoPromoteToQueen;
  final AutoZoomOutOnMoveBehaviour autoZoomOutOnMove;

  const LiveGameState({
    required this.game,
    required this.myColor,
    required this.gameDisbanded,
    required this.drawOfferResponded,
    required this.undoRequestResponded,
    required this.failedToJoinTheGame,
    required this.enableZoomButton,
    required this.showZoomOutButtonOnLeft,
    required this.showLegalMoves,
    required this.autoPromoteToQueen,
    required this.autoZoomOutOnMove,
  });

  const LiveGameState.initial({
    required this.showZoomOutButtonOnLeft,
    required this.showLegalMoves,
    required this.autoPromoteToQueen,
    required this.autoZoomOutOnMove,
  })  : game = null,
        myColor = null,
        gameDisbanded = false,
        drawOfferResponded = null,
        undoRequestResponded = null,
        failedToJoinTheGame = false,
        enableZoomButton = false;

  LiveGameState copyWith({
    InsanichessLiveGame? game,
    insanichess.PieceColor? myColor,
    bool? gameDisbanded,
    bool? drawOfferResponded,
    bool? undoRequestResponded,
    bool? failedToJoinTheGame,
    bool? enableZoomButton,
  }) {
    return LiveGameState(
      game: game ?? this.game,
      myColor: myColor ?? this.myColor,
      gameDisbanded: gameDisbanded ?? this.gameDisbanded,
      drawOfferResponded: drawOfferResponded,
      undoRequestResponded: undoRequestResponded,
      failedToJoinTheGame: failedToJoinTheGame ?? this.failedToJoinTheGame,
      enableZoomButton: enableZoomButton ?? this.enableZoomButton,
      showZoomOutButtonOnLeft: showZoomOutButtonOnLeft,
      showLegalMoves: showLegalMoves,
      autoPromoteToQueen: autoPromoteToQueen,
      autoZoomOutOnMove: autoZoomOutOnMove,
    );
  }
}
