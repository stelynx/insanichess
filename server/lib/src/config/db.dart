import 'dart:io';

/// Database config.
class DbConfig {
  /// Host where the database server is, e.g. 'localhost'.
  final String host;

  /// Port on which database is listening, e.g. 5432.
  final int port;

  /// The name of database, e.g. 'insanichess_db'.
  final String databaseName;

  /// The username of the user that has access to [databaseName].
  final String username;

  /// The password of the user with [username].
  final String password;

  /// Constructs new `DbConfig` object with given arguments.
  const DbConfig({
    required this.host,
    required this.port,
    required this.databaseName,
    required this.username,
    required this.password,
  });

  /// Constructs new `DbConfig` object by reading environment variables.
  /// This constructor can throw a null-check error in case any of the required
  /// environment variables is not set.
  DbConfig.fromEnvironment()
      : host = Platform.environment['INSANICHESS_DB_HOST']!,
        port = int.parse(Platform.environment['INSANICHESS_DB_PORT']!),
        databaseName = Platform.environment['INSANICHESS_DB_NAME']!,
        username = Platform.environment['INSANICHESS_DB_USERNAME']!,
        password = Platform.environment['INSANICHESS_DB_PASSWORD']!;
}
