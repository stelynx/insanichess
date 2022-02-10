import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../memory/memory.dart';
import '../../../services/database/database_service.dart';
import '../../../util/either.dart';
import '../../../util/failures/database_failure.dart';
import '../../../util/functions/body_parser.dart';
import '../../../util/functions/default_responses.dart';
import '../../../util/functions/jwt.dart';

/// Controller that handles API requests regarding online players as a group.
class OnlinePlayersController {
  /// Instance of database service.
  final DatabaseService _databaseService;

  /// Constructs new [OnlinePlayersController] object with [databaseService].
  const OnlinePlayersController({required DatabaseService databaseService})
      : _databaseService = databaseService;

  /// Handler for GET number of currently online players.
  ///
  /// Returns number of currently online players.
  ///
  /// The [request] does not need to be authenticated.
  void handleGetNumberOfOnlinePlayers(HttpRequest request) {
    return respondWithText(request, memory.onlinePlayers.length);
  }

  /// Handler for POST status of player online.
  ///
  /// Returns 500 if something goes south, 401 if the request is not authorized,
  /// 400 if the payload does not contain a boolean value for 'online' key,
  /// otherwise the response code is 200.
  ///
  /// Updates `memory.onlinePlayers` by either adding or removing the player
  /// submitting this request, based on the value of 'online' key in body.
  Future<void> handleNotifyPlayerOnlineOffline(HttpRequest request) async {
    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    // Get player.
    final Either<DatabaseFailure, InsanichessPlayer?>
        playerWithUserIdOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerWithUserIdOrFailure.isError() ||
        !playerWithUserIdOrFailure.hasValue()) {
      return respondWithInternalServerError(request);
    }

    final Map<String, dynamic> body = await parseBodyFromRequest(request);
    if (body['online'] is! bool) return respondWithBadRequest(request);

    if (body['online']) {
      memory.onlinePlayers.add(playerWithUserIdOrFailure.value!);
    } else {
      memory.onlinePlayers.remove(playerWithUserIdOrFailure.value!);
    }

    return respondWithOk(request);
  }
}
