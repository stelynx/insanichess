part of 'global_bloc.dart';

class GlobalState {
  final InsanichessSettings? settings;
  final String? jwtToken;
  final InsanichessPlayer? playerMyself;

  const GlobalState({
    required this.settings,
    required this.jwtToken,
    required this.playerMyself,
  });

  const GlobalState.initial()
      : settings = null,
        jwtToken = null,
        playerMyself = null;

  GlobalState copyWith({
    InsanichessSettings? settings,
    String? jwtToken,
    InsanichessPlayer? playerMyself,
  }) {
    return GlobalState(
      settings: settings ?? this.settings,
      jwtToken: jwtToken ?? this.jwtToken,
      playerMyself: playerMyself ?? this.playerMyself,
    );
  }
}
