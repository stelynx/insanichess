part of 'game_bloc.dart';

@immutable
abstract class _GameEvent {
  const _GameEvent();
}

class _Move extends _GameEvent {
  final insanichess.Square from;
  final insanichess.Square to;
  final insanichess.Piece? promotionTo;

  const _Move(this.from, this.to, [this.promotionTo]);
}

class _ZoomChanged extends _GameEvent {
  final double value;

  const _ZoomChanged(this.value);
}

class _ResetZoom extends _GameEvent {
  const _ResetZoom();
}

class _Undo extends _GameEvent {
  const _Undo();
}

class _Forward extends _GameEvent {
  const _Forward();
}

class _Backward extends _GameEvent {
  const _Backward();
}

class _StartNewGame extends _GameEvent {
  const _StartNewGame();
}
