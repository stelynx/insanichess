import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:postgres/postgres.dart';

import '../../config/db.dart';
import '../../util/either.dart';
import '../../util/failures/database_failure.dart';
import '../../util/logger.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance!;

  final Logger _logger;

  DatabaseService._({required Logger logger}) : _logger = logger;

  factory DatabaseService({required Logger logger}) {
    if (_instance != null) {
      throw StateError('DatabaseService already created');
    }

    _instance = DatabaseService._(logger: logger);
    return _instance!;
  }

  PostgreSQLConnection? _connection;

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

  Future<Either<DatabaseFailure, InsanichessUser>> createUser({
    required String email,
  }) async {
    _logger.debug(
      'DatabaseService.createUser',
      'creating user with email $email',
    );

    final PostgreSQLResult result;
    try {
      await _connection!
          .query("INSERT INTO ic_users (email) VALUES ('$email');");
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
    return value(InsanichessUser(id: newUser['id'], email: newUser['email']));
  }
}
