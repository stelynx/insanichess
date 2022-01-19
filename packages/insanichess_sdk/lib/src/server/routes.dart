/// Holds route definitions.
abstract class ICServerRoute {
  static const String api = 'api';
  static const String apiAuth = 'auth';
  static const String apiAuthLogin = 'login';
  static const String apiAuthRegister = 'register';
  static const String apiPlayer = 'player';
  static const String apiChallenge = 'challenge';
  static const String apiSettings = 'settings';

  static const String wss = 'wss';
  static const String wssGame = 'game';
  static const String wssGameWhite = 'white';
  static const String wssGameBlack = 'black';
}
