part of 'global_bloc.dart';

class GlobalState {
  final InsanichessSettings? settings;
  final String? jwtToken;
  final InsanichessPlayer? playerMyself;
  final InsanichessChallenge? challengePreference;

  const GlobalState({
    required this.settings,
    required this.jwtToken,
    required this.playerMyself,
    required this.challengePreference,
  });

  const GlobalState.initial()
      : settings = null,
        jwtToken = null,
        playerMyself = null,
        challengePreference = null;

  GlobalState copyWith({
    InsanichessSettings? settings,
    String? jwtToken,
    InsanichessPlayer? playerMyself,
    InsanichessChallenge? challengePreference,
  }) {
    return GlobalState(
      settings: settings ?? this.settings,
      jwtToken: jwtToken ?? this.jwtToken,
      playerMyself: playerMyself ?? this.playerMyself,
      challengePreference: challengePreference ?? this.challengePreference,
    );
  }
}
