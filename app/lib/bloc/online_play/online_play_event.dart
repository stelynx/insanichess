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
