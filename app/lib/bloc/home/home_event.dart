part of 'home_bloc.dart';

@immutable
abstract class _HomeEvent {
  const _HomeEvent();
}

class _RefreshMiscData extends _HomeEvent {
  const _RefreshMiscData();
}
