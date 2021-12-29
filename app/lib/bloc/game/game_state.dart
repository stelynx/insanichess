part of 'game_bloc.dart';

@immutable
class GameState {
  final InsanichessGame game;
  final bool enableZoomButton;
  final bool isWhiteBottom;
  final bool rotateOnMove;
  final bool mirrorTopPieces;
  final bool showZoomOutButtonOnLeft;
  final bool showLegalMoves;
  final bool autoPromoteToQueen;
  final bool allowUndo;
  final AutoZoomOutOnMoveBehaviour autoZoomOutOnMove;

  const GameState({
    required this.game,
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

  const GameState.initial({
    required this.game,
    required this.isWhiteBottom,
    required this.rotateOnMove,
    required this.mirrorTopPieces,
    required this.showZoomOutButtonOnLeft,
    required this.showLegalMoves,
    required this.autoPromoteToQueen,
    required this.allowUndo,
    required this.autoZoomOutOnMove,
  }) : enableZoomButton = false;

  GameState copyWith({
    InsanichessGame? game,
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
    return GameState(
      game: game ?? this.game,
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
