part of 'otb_game_bloc.dart';

@immutable
class OtbGameState {
  final InsanichessGame game;
  final Duration currentMoveDuration;
  final bool enableZoomButton;
  final bool isWhiteBottom;
  final bool rotateOnMove;
  final bool mirrorTopPieces;
  final bool showZoomOutButtonOnLeft;
  final bool showLegalMoves;
  final bool autoPromoteToQueen;
  final bool allowUndo;
  final AutoZoomOutOnMoveBehaviour autoZoomOutOnMove;

  const OtbGameState({
    required this.game,
    required this.currentMoveDuration,
    required this.enableZoomButton,
    required this.isWhiteBottom,
    required this.rotateOnMove,
    required this.mirrorTopPieces,
    required this.showZoomOutButtonOnLeft,
    required this.showLegalMoves,
    required this.autoPromoteToQueen,
    required this.allowUndo,
    required this.autoZoomOutOnMove,
  });

  const OtbGameState.initial({
    required this.game,
    required this.isWhiteBottom,
    required this.rotateOnMove,
    required this.mirrorTopPieces,
    required this.showZoomOutButtonOnLeft,
    required this.showLegalMoves,
    required this.autoPromoteToQueen,
    required this.allowUndo,
    required this.autoZoomOutOnMove,
  })  : enableZoomButton = false,
        currentMoveDuration = Duration.zero;

  OtbGameState copyWith({
    InsanichessGame? game,
    Duration? currentMoveDuration,
    bool? enableZoomButton,
    bool? isWhiteBottom,
    bool? rotateOnMove,
    bool? mirrorTopPieces,
    bool? showZoomOutButtonOnLeft,
    bool? showLegalMoves,
    bool? autoPromoteToQueen,
    bool? allowUndo,
    AutoZoomOutOnMoveBehaviour? autoZoomOutOnMove,
  }) {
    return OtbGameState(
      game: game ?? this.game,
      currentMoveDuration: currentMoveDuration ?? this.currentMoveDuration,
      enableZoomButton: enableZoomButton ?? this.enableZoomButton,
      isWhiteBottom: isWhiteBottom ?? this.isWhiteBottom,
      rotateOnMove: rotateOnMove ?? this.rotateOnMove,
      mirrorTopPieces: mirrorTopPieces ?? this.mirrorTopPieces,
      showZoomOutButtonOnLeft:
          showZoomOutButtonOnLeft ?? this.showZoomOutButtonOnLeft,
      showLegalMoves: showLegalMoves ?? this.showLegalMoves,
      autoPromoteToQueen: autoPromoteToQueen ?? this.autoPromoteToQueen,
      allowUndo: allowUndo ?? this.allowUndo,
      autoZoomOutOnMove: autoZoomOutOnMove ?? this.autoZoomOutOnMove,
    );
  }
}
