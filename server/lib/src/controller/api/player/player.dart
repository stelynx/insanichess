import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../services/database/database_service.dart';
import '../../../util/either.dart';
import '../../../util/failures/database_failure.dart';
import '../../../util/functions/body_parser.dart';
import '../../../util/functions/default_responses.dart';
import '../../../util/functions/jwt.dart';

/// Controller that handles player requests.
class PlayerController {
  /// Database service instance.
  final DatabaseService _databaseService;

  /// Constructs new `PlayerController` object with [databaseService].
  const PlayerController({required DatabaseService databaseService})
      : _databaseService = databaseService;

  /// Handler for POST player [request].
  ///
  /// If request is malformed, it returns 400. If request is not authenticated
  /// with JWT token, it sends back 401. If username is already in use or user
  /// already has player profile, the status code is 403. Otherwise, the player
  /// is created in database and 201 is sent back.
  ///
  /// Response contains data about the created player.
  Future<void> handleCreatePlayer(HttpRequest request) async {
    if (request.contentLength <= 0 &&
        request.headers.contentType?.value != ContentType.json.value) {
      return respondWithBadRequest(request);
    }

    final Map<String, dynamic> body = await parseBodyFromRequest(request);

    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    // Check username already in use.
    final String? username = body[InsanichessPlayerJsonKey.username];
    if (username == null || !InsanichessValidator.isValidUsername(username)) {
      return respondWithBadRequest(request);
    }

    final Either<DatabaseFailure, InsanichessPlayer?>
        playerWithUsernameOrFailure =
        await _databaseService.getPlayerWithUsername(username);
    if (playerWithUsernameOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }
    if (playerWithUsernameOrFailure.hasValue()) {
      return respondWithForbidden(request);
    }

    // Check if user has player.
    final Either<DatabaseFailure, InsanichessPlayer?>
        playerWithUserIdOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerWithUserIdOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }
    if (playerWithUserIdOrFailure.hasValue()) {
      return respondWithForbidden(request);
    }

    // Create player.
    final Either<DatabaseFailure, InsanichessPlayer> playerOrFailure =
        await _databaseService.createPlayer(
      username: username,
      userId: userIdIfValid,
    );

    if (playerOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }

    return respondWithJson(
      request,
      playerOrFailure.value.toJson(),
      statusCode: 201,
    );
  }

  /// Gets player data for user parsed from JWT token.
  ///
  /// The returned status code is 400 in case of malformed request, 500 in case
  /// of internal server error, 401 in case JWT token is not valid, 404 in case
  /// user does not have player data, and 200 with player data in body if player
  /// found.
  Future<void> handleGetPlayerMyself(HttpRequest request) async {
    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    // Get player.
    final Either<DatabaseFailure, InsanichessPlayer?>
        playerWithUserIdOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerWithUserIdOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }

    return playerWithUserIdOrFailure.hasValue()
        ? respondWithJson(request, playerWithUserIdOrFailure.value!.toJson())
        : respondWithNotFound(request);
  }
}
