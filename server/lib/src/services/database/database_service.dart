import 'package:dbcrypt/dbcrypt.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:postgres/postgres.dart';

import '../../config/db.dart';
import '../../util/either.dart';
import '../../util/failures/database_failure.dart';
import '../../util/functions/on_entity.dart';
import '../../util/functions/prepare_arg_for_query.dart';
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

  Future<void> addLog(String level, String location, String message) async {
    await _connection!.query(
        "INSERT INTO ic_logs (log_level, log_location, log_message) VALUES ('${prepareArgForQuery(level)}', '${prepareArgForQuery(location)}', '${prepareArgForQuery(message)}');");
  }

  /// Checks if user with [email] and [password] exists. If [password] is `null`
  /// only email is checked.
  ///
  /// Returns `true` if user exists, otherwise `false`. If something goes south,
  /// it returns `DatabaseFailure` instead.
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
          "SELECT hashed_password FROM ic_users WHERE email = '${prepareArgForQuery(email)}' LIMIT 1;");
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
        "SELECT * FROM ic_users WHERE email = '${prepareArgForQuery(email)}' LIMIT 1;",
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
        "INSERT INTO ic_users (email, hashed_password) VALUES ('${prepareArgForQuery(email)}', '$hashedPassword');",
      );
      result = await _connection!.query(
        "SELECT * FROM ic_users WHERE email = '${prepareArgForQuery(email)}' LIMIT 1;",
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
        "UPDATE ic_users SET email = '${prepareArgForQuery(user.email)}' WHERE id = '${prepareArgForQuery(user.id)}';",
      );
    } catch (e) {
      _logger.error('DatabaseService.updateUser', e);
      return error(const DatabaseFailure());
    }

    _logger.info('DatabaseService.updateUser', 'user ${user.id} updated');
    return value(null);
  }

  /// Gets the player with [username].
  ///
  /// Returns `InsanichessPlayer` if the user exists, otherwise `null`. In case
  /// something goes south, the return error is `DatabaseFailure`.
  Future<Either<DatabaseFailure, InsanichessPlayer?>> getPlayerWithUsername(
    String username,
  ) async {
    _logger.debug(
      'DatabaseService.getPlayerWithUsername',
      'getting player with username "$username"',
    );

    final PostgreSQLResult result;
    try {
      result = await _connection!.query(
        "SELECT * FROM ic_players WHERE username = '${prepareArgForQuery(username)}' LIMIT 1;",
      );
    } catch (e) {
      _logger.error('DatabaseService.getUserWithEmail', e);
      return error(const DatabaseFailure());
    }

    if (result.isEmpty) {
      _logger.debug(
        'DatabaseService.getPlayerWithUsername',
        'player with username "$username" does not exist',
      );
      return value(null);
    }

    final Map<String, dynamic> playerData = result.first.toColumnMap();
    return value(
      InsanichessPlayer(
        id: playerData['id'],
        username: playerData['username'],
      ),
    );
  }

  /// Deletes [user] from database. This call should be always made only
  /// internal if something in the process of registration fails but user was
  /// already created in database.
  Future<Either<DatabaseFailure, void>> deleteUser(InsanichessUser user) async {
    _logger.info(
      'DatabaseService.deleteUser',
      'deleting user id "${user.id}"',
    );

    try {
      await _connection!.query(
          "DELETE FROM ic_users WHERE id = '${prepareArgForQuery(user.id)}';");
    } catch (e) {
      _logger.error('DatabaseService.deleteUser', e);
      return error(const DatabaseFailure());
    }

    return value(null);
  }

  /// Gets the player with [userId].
  ///
  /// Returns `InsanichessPlayer` if the user exists, otherwise `null`. In case
  /// something goes south, the return error is `DatabaseFailure`.
  Future<Either<DatabaseFailure, InsanichessPlayer?>> getPlayerWithUserId(
    String userId,
  ) async {
    _logger.debug(
      'DatabaseService.getPlayerWithUsername',
      'getting player with user id "$userId"',
    );

    final PostgreSQLResult result;
    try {
      result = await _connection!.query(
        "SELECT * FROM ic_players WHERE ic_user = '${prepareArgForQuery(userId)}' LIMIT 1;",
      );
    } catch (e) {
      _logger.error('DatabaseService.getUserWithUserId', e);
      return error(const DatabaseFailure());
    }

    if (result.isEmpty) {
      _logger.debug(
        'DatabaseService.getPlayerWithUsername',
        'player with user id "$userId" does not exist',
      );
      return value(null);
    }

    final Map<String, dynamic> playerData = result.first.toColumnMap();
    return value(
      InsanichessPlayer(
        id: playerData['id'],
        username: playerData['username'],
      ),
    );
  }

  /// Creates the player with [username].
  ///
  /// Returns newly created `InsanichessUser`. In case something goes south, the
  /// return error is `DatabaseFailure`.
  Future<Either<DatabaseFailure, InsanichessPlayer>> createPlayer({
    required String username,
    required String userId,
  }) async {
    _logger.debug(
      'DatabaseService.createPlayer',
      'creating player with username "$username"',
    );

    final PostgreSQLResult result;
    try {
      await _connection!.query(
          "INSERT INTO ic_players (username, ic_user) VALUES ('${prepareArgForQuery(username)}', '${prepareArgForQuery(userId)}');");
      result = await _connection!.query(
          "SELECT * FROM ic_players WHERE username = '${prepareArgForQuery(username)}' LIMIT 1;");
    } catch (e) {
      _logger.error('DatabaseService.createPlayer', e);
      return error(const DatabaseFailure());
    }

    _logger.info(
      'DatabaseService.createPlayer',
      'player with username $username created',
    );

    final Map<String, dynamic> newPlayer = result.first.toColumnMap();

    return value(InsanichessPlayer(
      id: newPlayer['id'],
      username: newPlayer['username'],
    ));
  }

  /// Creates default settings for user with [userId].
  Future<Either<DatabaseFailure, InsanichessSettings>>
      createDefaultSettingsForUserWithUserId(
    String userId,
  ) async {
    _logger.debug(
      'DatabaseService.createDefaultSettingsForUser',
      'creating settings for user with id "$userId"',
    );

    final PostgreSQLResult result;
    try {
      await _connection!.query(
          "INSERT INTO ic_user_settings (ic_user) VALUES ('${prepareArgForQuery(userId)}');");
      result = await _connection!.query(
          "SELECT * FROM ic_user_settings WHERE ic_user = '${prepareArgForQuery(userId)}' LIMIT 1");
    } catch (e) {
      _logger.error('DatabaseService.createDefaultSettingsForUser', e);
      return error(const DatabaseFailure());
    }

    _logger.info(
      'DatabaseService.createDefaultSettingsForUser',
      'settings for user with id  $userId created',
    );

    final Map<String, dynamic> data = result.first.toColumnMap();
    final InsanichessSettings? settings = settingsFromDatabase(data);
    if (settings == null) {
      await _connection!.query(
          "DELETE FROM ic_user_settings WHERE id = '${prepareArgForQuery(data['id'])}';");
      return error(const DatabaseFailure());
    }

    return value(settings);
  }

  /// Returns `InsanichessSettings` for user with [userId].
  Future<Either<DatabaseFailure, InsanichessSettings?>>
      getSettingsForUserWithUserId(String userId) async {
    _logger.debug(
      'DatabaseService.getSettingsForUserWithUserId',
      'getting settings for user with id "$userId"',
    );

    final PostgreSQLResult result;
    try {
      result = await _connection!.query(
          "SELECT * FROM ic_user_settings WHERE ic_user = '${prepareArgForQuery(userId)}' LIMIT 1");
    } catch (e) {
      _logger.error('DatabaseService.getSettingsForUserWithUserId', e);
      return error(const DatabaseFailure());
    }

    _logger.debug(
      'DatabaseService.getSettingsForUserWithUserId',
      'settings for user with id $userId acquired',
    );

    if (result.isEmpty) return value(null);

    final Map<String, dynamic> data = result.first.toColumnMap();
    final InsanichessSettings? settings = settingsFromDatabase(data);
    if (settings == null) {
      return error(const DatabaseFailure());
    }

    return value(settings);
  }

  /// Updates setting [columnName] with [columnValue] for user with [userId].
  Future<Either<DatabaseFailure, void>> updateSettingsValue(
    String columnName,
    dynamic columnValue, {
    required String userId,
  }) async {
    _logger.debug(
      'DatabaseService.updateSettings',
      'updating settings for user with id "$userId"',
    );

    try {
      if (columnValue is String) {
        await _connection!.query(
            "UPDATE ic_user_settings SET ${prepareArgForQuery(columnName)} = '${prepareArgForQuery(columnValue)}' WHERE ic_user = '${prepareArgForQuery(userId)}';");
      } else if (columnValue is bool || columnValue is int) {
        await _connection!.query(
            "UPDATE ic_user_settings SET ${prepareArgForQuery(columnName)} = $columnValue} WHERE ic_user = '${prepareArgForQuery(userId)}';");
      }
    } catch (e) {
      _logger.error('DatabaseService.updateSettingsValue', e);
      return error(const DatabaseFailure());
    }

    return value(null);
  }

  /// Fetches "allow undo" setting for live games of user with id [playerId].
  ///
  /// This method assumes settings are present and returns [DatabaseFailure] in
  /// case of any king of error.
  Future<Either<DatabaseFailure, bool>> playerAllowsUndoInLiveGame(
    String playerId,
  ) async {
    _logger.debug(
      'DatabaseService.userAllowsUndoInLiveGame',
      'checking if player with id = "$playerId" allows undo',
    );

    try {
      final PostgreSQLResult userResult = await _connection!.query(
          "SELECT ic_user FROM ic_players WHERE id = '${prepareArgForQuery(playerId)}' LIMIT 1;");
      final String userId = userResult.first.toColumnMap()['ic_user'];
      final PostgreSQLResult result = await _connection!.query(
          "SELECT live_allow_undo FROM ic_user_settings WHERE ic_user = '${prepareArgForQuery(userId)}' LIMIT 1;");
      return value(result.first.toColumnMap()['live_allow_undo']);
    } catch (e) {
      _logger.error('DatabaseService.userAllowsUndoInLiveGame', e);
      return error(const DatabaseFailure());
    }
  }

  /// Saves a [game] in the database.
  ///
  /// The id from the game is ignored and is automatically set by the database.
  Future<Either<DatabaseFailure, void>> saveGame(InsanichessGame game) async {
    _logger.debug(
      'DatabaseService.saveGame',
      'saving game',
    );

    String movesString;
    if (game.movesPlayed.isEmpty) {
      movesString = 'ARRAY[]::text[]';
    } else {
      movesString = "'{";
      for (final insanichess.PlayedMove move in game.movesPlayed) {
        movesString += '"${move.toICString()}", ';
      }
      movesString = movesString.substring(0, movesString.length - 2) + "}'";
    }

    String timesString;
    if (game.timesSpentPerMove.isEmpty) {
      timesString = 'ARRAY[]::integer[]';
    } else {
      timesString = "'{";
      for (final Duration timeSpent in game.timesSpentPerMove) {
        timesString += '${timeSpent.inMilliseconds}, ';
      }
      timesString = timesString.substring(0, timesString.length - 2) + "}'";
    }

    try {
      await _connection!.query(
          "INSERT INTO ic_games (player_white, player_black, time_control_initial, time_control_increment, times_per_move, game_status, moves) VALUES ('${prepareArgForQuery(game.whitePlayer.id)}', '${prepareArgForQuery(game.blackPlayer.id)}', ${game.timeControl.initialTime.inSeconds}, ${game.timeControl.incrementPerMove.inSeconds}, $timesString, ${game.status.toJson()}, $movesString);");
    } catch (e) {
      _logger.error('DatabaseService.saveGame', e);
      return error(const DatabaseFailure());
    }

    return value(null);
  }
}
