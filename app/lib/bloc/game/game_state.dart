part of 'game_bloc.dart';

@immutable
class GameState {
  final InsanichessGame game;
  final bool enableZoomButton;
  final bool isWhiteBottom;
  final bool rotateOnMove;
  final bool mirrorTopPieces;

  const GameState({
    required this.game,
    required this.enableZoomButton,
    required this.isWhiteBottom,
    required this.rotateOnMove,
    required this.mirrorTopPieces,
  });

  const GameState.initial({
    required this.game,
    required this.isWhiteBottom,
    required this.rotateOnMove,
    required this.mirrorTopPieces,
  }) : enableZoomButton = false;

  GameState copyWith({
    InsanichessGame? game,
    bool? enableZoomButton,
    bool? isWhiteBottom,
    bool? rotateOnMove,
    bool? mirrorTopPieces,
  }) {
    return GameState(
      game: game ?? this.game,
      enableZoomButton: enableZoomButton ?? this.enableZoomButton,
      isWhiteBottom: isWhiteBottom ?? this.isWhiteBottom,
      rotateOnMove: rotateOnMove ?? this.rotateOnMove,
      mirrorTopPieces: mirrorTopPieces ?? this.mirrorTopPieces,
    );
  }
}
