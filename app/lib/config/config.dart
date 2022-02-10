abstract class Config {
  static const String backendHost = 'localhost';
  static const int backendPort = 4040;
  static const String backendApiScheme = 'http';
  static const String backendWssScheme = 'ws';

  static const Duration miscDataRefreshFrequency = Duration(seconds: 5);
}
