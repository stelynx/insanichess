part of 'live_game_bloc.dart';

@immutable
abstract class _LiveGameEvent {
  const _LiveGameEvent();
}

class _Initialize extends _LiveGameEvent {
  final String liveGameId;

  const _Initialize({required this.liveGameId});
}

class _GameEventReceived extends _LiveGameEvent {
  final InsanichessGameEvent gameEvent;

  const _GameEventReceived(this.gameEvent);
}

class _Move extends _LiveGameEvent {
  final insanichess.Move move;

  const _Move(this.move);
}

class _RequestUndo extends _LiveGameEvent {
  const _RequestUndo();
}

class _CancelUndo extends _LiveGameEvent {
  const _CancelUndo();
}

class _RespondToUndo extends _LiveGameEvent {
  final bool accept;

  const _RespondToUndo(this.accept);
}

class _OfferDraw extends _LiveGameEvent {
  const _OfferDraw();
}

class _CancelOfferDraw extends _LiveGameEvent {
  const _CancelOfferDraw();
}

class _RespondToOfferDraw extends _LiveGameEvent {
  final bool accept;

  const _RespondToOfferDraw(this.accept);
}

class _Resign extends _LiveGameEvent {
  const _Resign();
}

class _ZoomChanged extends _LiveGameEvent {
  final double value;

  const _ZoomChanged(this.value);
}

class _ResetZoom extends _LiveGameEvent {
  const _ResetZoom();
}

class _Forward extends _LiveGameEvent {
  const _Forward();
}

class _Backward extends _LiveGameEvent {
  const _Backward();
}
