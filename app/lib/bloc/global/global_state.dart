part of 'global_bloc.dart';

class GlobalState {
  final InsanichessSettings? settings;
  final String? jwtToken;

  const GlobalState({
    required this.settings,
    required this.jwtToken,
  });

  const GlobalState.initial()
      : settings = null,
        jwtToken = null;

  GlobalState copyWith({
    InsanichessSettings? settings,
    String? jwtToken,
  }) {
    return GlobalState(
      settings: settings ?? this.settings,
      jwtToken: jwtToken ?? this.jwtToken,
    );
  }
}
