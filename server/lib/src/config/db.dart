import 'dart:io';

class DbConfig {
  final String host;
  final int port;
  final String databaseName;
  final String username;
  final String password;

  DbConfig({
    required this.host,
    required this.port,
    required this.databaseName,
    required this.username,
    required this.password,
  });

  DbConfig.fromEnvironment()
      : host = Platform.environment['INSANICHESS_DB_HOST']!,
        port = int.parse(Platform.environment['INSANICHESS_DB_PORT']!),
        databaseName = Platform.environment['INSANICHESS_DB_NAME']!,
        username = Platform.environment['INSANICHESS_DB_USERNAME']!,
        password = Platform.environment['INSANICHESS_DB_PASSWORD']!;
}
