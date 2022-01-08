import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:postgres/postgres.dart';

import '../../config/db.dart';
import '../../util/either.dart';
import '../../util/failures/database_failure.dart';
import '../../util/logger.dart';

/// Service for communication with database.
class DatabaseService {
  /// Instance of this service. It is created the first time a factory
  /// constructor is called.
  static DatabaseService? _instance;

  /// Getter for the [_instance].
  static DatabaseService get instance => _instance!;

  /// Logger instance.
  final Logger _logger;

  /// Internal constructor.
  DatabaseService._({required Logger logger}) : _logger = logger;

  /// Constructs and returns a new `DatabaseService` instance.
  ///
  /// Calling this factory for the second time throws `StateError`.
  factory DatabaseService({required Logger logger}) {
    if (_instance != null) {
      throw StateError('DatabaseService already created');
    }

    _instance = DatabaseService._(logger: logger);
    return _instance!;
  }

  /// Connection to PostgreSQL database.
  PostgreSQLConnection? _connection;

  /// Initializes this service by connecting to database with [config].
  Future<bool> initialize({required DbConfig config}) async {
    _logger.info('DatabaseService.initialize', 'initializing');

    _connection = PostgreSQLConnection(
      config.host,
      config.port,
      config.databaseName,
      username: config.username,
      password: config.password,
    );

    try {
      await _connection!.open();
      _logger.info('DatabaseService.initialize', 'connection opened');
      return true;
    } catch (e) {
      _logger.error('DatabaseService.initialize', e);
      return false;
    }
  }

  /// Gets the user with [email]. This method does not set the appleId field of
  /// the user, because it is meant to be only called on login attempts without
  /// Apple ID provided.
  ///
  /// Returns `InsanichessUser` if the user exists, otherwise `null`. In case
  /// something goes south, the return error is `DatabaseFailure`.
  Future<Either<DatabaseFailure, InsanichessUser?>> getUserWithEmail(
    String email,
  ) async {
    _logger.debug(
      'DatabaseService.getUserWithEmail',
      'getting user with email $email',
    );

    final PostgreSQLResult result;
    try {
      result = await _connection!.query(
        "SELECT * FROM ic_users WHERE email = '$email' LIMIT 1;",
      );
    } catch (e) {
      _logger.error('DatabaseService.getUserWithEmail', e);
      return error(const DatabaseFailure());
    }

    if (result.isEmpty) return value(null);

    final Map<String, dynamic> userData = result.first.toColumnMap();
    return value(
      InsanichessUser(
        id: userData['id'],
        email: userData['email'],
      ),
    );
  }

  /// Gets the user with [appleId].
  ///
  /// Returns `InsanichessUser` if the user exists, otherwise `null`. In case
  /// something goes south, the return error is `DatabaseFailure`.
  Future<Either<DatabaseFailure, InsanichessUser?>> getUserWithAppleId(
    String appleId,
  ) async {
    _logger.debug(
      'DatabaseService.getUserWithAppleId',
      'getting user with email $appleId',
    );

    final PostgreSQLResult result;
    try {
      result = await _connection!.query(
        "SELECT * FROM ic_users WHERE apple_id = '$appleId' LIMIT 1;",
      );
    } catch (e) {
      _logger.error('DatabaseService.getUserWithAppleId', e);
      return error(const DatabaseFailure());
    }

    if (result.isEmpty) return value(null);

    final Map<String, dynamic> userData = result.first.toColumnMap();
    return value(
      InsanichessUser(
        id: userData['id'],
        email: userData['email'],
        appleId: userData['apple_id'],
      ),
    );
  }

  /// Creates the user with [email] and optional [appleId].
  ///
  /// Returns newly created `InsanichessUser`. In case something goes south, the
  /// return error is `DatabaseFailure`.
  Future<Either<DatabaseFailure, InsanichessUser>> createUser({
    required String email,
    String? appleId,
  }) async {
    _logger.debug(
      'DatabaseService.createUser',
      'creating user with email $email',
    );

    final PostgreSQLResult result;
    try {
      await _connection!.query(
        appleId == null
            ? "INSERT INTO ic_users (email) VALUES ('$email');"
            : "INSERT INTO ic_users (email, apple_id) VALUES ('$email', '$appleId');",
      );
      result = await _connection!.query(
        "SELECT * FROM ic_users WHERE email = '$email' LIMIT 1;",
      );
    } catch (e) {
      _logger.error('DatabaseService.createUser', e);
      return error(const DatabaseFailure());
    }

    _logger.info(
      'DatabaseService.createUser',
      'user with email "$email" created',
    );

    final Map<String, dynamic> newUser = result.first.toColumnMap();
    return value(InsanichessUser(
      id: newUser['id'],
      email: newUser['email'],
      appleId: newUser['apple_id'],
    ));
  }

  /// Updates [user].
  ///
  /// In case something goes south, the return error is `DatabaseFailure`.
  Future<Either<DatabaseFailure, void>> updateUser(InsanichessUser user) async {
    _logger.debug('DatabaseService.updateUser', 'updating user ${user.id}');

    try {
      await _connection!.query(
        "UPDATE ic_users SET email = '${user.email}', apple_id = ${user.appleId == null ? 'NULL' : "'${user.appleId}'"} WHERE id = '${user.id}';",
      );
    } catch (e) {
      _logger.error('DatabaseService.updateUser', e);
      return error(const DatabaseFailure());
    }

    _logger.info('DatabaseService.updateUser', 'user ${user.id} updated');
    return value(null);
  }
}
