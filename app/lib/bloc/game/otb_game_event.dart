part of 'otb_game_bloc.dart';

@immutable
abstract class _OtbGameEvent {
  const _OtbGameEvent();
}

class _Move extends _OtbGameEvent {
  final insanichess.Move move;

  const _Move(this.move);
}

class _TimerTick extends _OtbGameEvent {
  const _TimerTick();
}

class _ZoomChanged extends _OtbGameEvent {
  final double value;

  const _ZoomChanged(this.value);
}

class _ResetZoom extends _OtbGameEvent {
  const _ResetZoom();
}

class _Undo extends _OtbGameEvent {
  const _Undo();
}

class _Forward extends _OtbGameEvent {
  const _Forward();
}

class _Backward extends _OtbGameEvent {
  const _Backward();
}

class _AgreeToDraw extends _OtbGameEvent {
  const _AgreeToDraw();
}

class _Resign extends _OtbGameEvent {
  const _Resign();
}

class _StartNewGame extends _OtbGameEvent {
  const _StartNewGame();
}
