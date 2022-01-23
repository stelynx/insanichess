import 'dart:async';
import 'dart:io';

import '../../../memory/memory.dart';
import '../../../util/functions/default_responses.dart';
import '../../../util/functions/jwt.dart';

/// Controller that handles live game API requests.
class LiveGameController {
  /// Constructs new [LiveGameController] object.
  const LiveGameController();

  /// Handler for GET live game.
  ///
  /// Returns data about live game with temporary [gameId].
  ///
  /// Response is 500 in case of internal server error, 401 if no JWT token is
  /// provided, 400 in case [gameId] is empty, 404 if game with [gameId] not
  /// found in [memory.gamesInProgress], and 200 if the game is found with game
  /// details in body.
  ///
  /// Returns live game details.
  Future<void> handleGetLiveGameDetails(
    HttpRequest request, {
    required String gameId,
  }) async {
    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    if (gameId.isEmpty) return respondWithBadRequest(request);

    if (!memory.gamesInProgress.containsKey(gameId)) {
      return respondWithNotFound(request);
    }

    return respondWithJson(
      request,
      memory.gamesInProgress[gameId]!.toJson(),
    );
  }
}
