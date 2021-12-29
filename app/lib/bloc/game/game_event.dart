part of 'game_bloc.dart';

@immutable
abstract class _GameEvent {
  const _GameEvent();
}

class _Move extends _GameEvent {
  final insanichess.Move move;

  const _Move(this.move);
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
