/// Holds route definitions.
abstract class ICServerRoute {
  static const String api = 'api';
  static const String apiAuth = 'auth';
  static const String apiAuthLogin = 'login';
  static const String apiAuthRegister = 'register';
  static const String apiPlayer = 'player';
  static const String apiPlayers = 'players';
  static const String apiPlayersOnline = 'online';
  static const String apiPlayersOnlineCount = 'count';
  static const String apiSettings = 'settings';
  static const String apiChallenge = 'challenge';
  static const String apiChallengeAccept = 'accept';
  static const String apiChallengeDecline = 'decline';
  static const String apiGame = 'game';
  static const String apiGameLive = 'live';
  static const String apiGames = 'games';
  static const String apiGamesLive = 'live';
  static const String apiGamesLiveCount = 'count';

  static const String wss = 'wss';
  static const String wssGame = 'game';
  static const String wssGameWhite = 'white';
  static const String wssGameBlack = 'black';
}
