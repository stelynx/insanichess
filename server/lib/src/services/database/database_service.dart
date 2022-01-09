import 'package:dbcrypt/dbcrypt.dart';
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

  Future<Either<DatabaseFailure, bool>> existsUserWithEmailAndPassword(
    String email, [
    String? password,
  ]) async {
    _logger.debug(
      'DatabaseService.existsUserWithEmailAndPassword',
      'checking user with email $email and password',
    );

    final PostgreSQLResult result;
    try {
      result = await _connection!.query(
          "SELECT hashed_password FROM ic_users WHERE email = '$email' LIMIT 1;");
    } catch (e) {
      _logger.error('DatabaseService.existsUserWithEmailAndPassword', e);
      return error(const DatabaseFailure());
    }

    if (result.isEmpty) {
      _logger.debug(
        'DatabaseService.existsUserWithEmailAndPassword',
        'user with email $email and given password does not exists',
      );
      return value(false);
    }

    return value(password == null
        ? true
        : DBCrypt()
            .checkpw(password, result.first.toColumnMap()['hashed_password']));
  }

  /// Gets the user with [email].
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

    if (result.isEmpty) {
      _logger.debug(
        'DatabaseService.getUserWithEmail',
        'user with email $email does not exist',
      );
      return value(null);
    }

    final Map<String, dynamic> userData = result.first.toColumnMap();
    return value(
      InsanichessUser(
        id: userData['id'],
        email: userData['email'],
      ),
    );
  }

  /// Creates the user with [email] and plain [password].
  ///
  /// Returns newly created `InsanichessUser`. In case something goes south, the
  /// return error is `DatabaseFailure`.
  Future<Either<DatabaseFailure, InsanichessUser>> createUser({
    required String email,
    required String password,
  }) async {
    _logger.debug(
      'DatabaseService.createUser',
      'creating user with email $email',
    );

    final String hashedPassword =
        DBCrypt().hashpw(password, DBCrypt().gensalt());

    final PostgreSQLResult result;
    try {
      await _connection!.query(
        "INSERT INTO ic_users (email, hashed_password) VALUES ('$email', '$hashedPassword');",
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
    ));
  }

  /// Updates [user].
  ///
  /// In case something goes south, the return error is `DatabaseFailure`.
  Future<Either<DatabaseFailure, void>> updateUser(InsanichessUser user) async {
    _logger.debug('DatabaseService.updateUser', 'updating user ${user.id}');

    try {
      await _connection!.query(
        "UPDATE ic_users SET email = '${user.email}' WHERE id = '${user.id}';",
      );
    } catch (e) {
      _logger.error('DatabaseService.updateUser', e);
      return error(const DatabaseFailure());
    }

    _logger.info('DatabaseService.updateUser', 'user ${user.id} updated');
    return value(null);
  }
}
