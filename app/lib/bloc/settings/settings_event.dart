part of 'settings_bloc.dart';

@immutable
abstract class _SettingsEvent {
  const _SettingsEvent();
}

class _ToggleOtbRotateChessBoard extends _SettingsEvent {
  const _ToggleOtbRotateChessBoard();
}

class _ToggleOtbMirrorTopPieces extends _SettingsEvent {
  const _ToggleOtbMirrorTopPieces();
}

class _ToggleOtbAllowUndo extends _SettingsEvent {
  const _ToggleOtbAllowUndo();
}

class _ToggleOtbAlwaysPromoteToQueen extends _SettingsEvent {
  const _ToggleOtbAlwaysPromoteToQueen();
}

class _ToggleOtbAutoZoomOutOnMove extends _SettingsEvent {
  const _ToggleOtbAutoZoomOutOnMove();
}

class _ToggleShowLegalMoves extends _SettingsEvent {
  const _ToggleShowLegalMoves();
}

class _ToggleShowZoomButtonOnLeft extends _SettingsEvent {
  const _ToggleShowZoomButtonOnLeft();
}
