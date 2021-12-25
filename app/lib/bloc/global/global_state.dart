part of 'global_bloc.dart';

class GlobalState {
  final InsanichessSettings? settings;

  const GlobalState({
    required this.settings,
  });

  const GlobalState.initial() : settings = null;

  GlobalState copyWith({
    InsanichessSettings? settings,
  }) {
    return GlobalState(
      settings: settings ?? this.settings,
    );
  }
}
