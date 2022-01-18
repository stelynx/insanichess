part of 'online_play_bloc.dart';

@immutable
abstract class _OnlinePlayEvent {
  const _OnlinePlayEvent();
}

class _ToggleEditingTimeControl extends _OnlinePlayEvent {
  const _ToggleEditingTimeControl();
}

class _ToggleEditingPreferColor extends _OnlinePlayEvent {
  const _ToggleEditingPreferColor();
}

class _TimeControlChanged extends _OnlinePlayEvent {
  final InsanichessTimeControl value;

  const _TimeControlChanged(this.value);
}

class _PreferredColorChanged extends _OnlinePlayEvent {
  final insanichess.PieceColor? value;

  const _PreferredColorChanged(this.value);
}

class _ChallengeCreated extends _OnlinePlayEvent {
  const _ChallengeCreated();
}

class _ShowChallengeDeclinedToast extends _OnlinePlayEvent {
  const _ShowChallengeDeclinedToast();
}

class _HideChallengeDeclinedToast extends _OnlinePlayEvent {
  const _HideChallengeDeclinedToast();
}
