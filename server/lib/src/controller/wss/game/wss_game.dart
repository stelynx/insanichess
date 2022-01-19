import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../memory/memory.dart';
import '../../../services/database/database_service.dart';
import '../../../util/either.dart';
import '../../../util/failures/database_failure.dart';
import '../../../util/functions/default_responses.dart';
import '../../../util/functions/jwt.dart';

/// Controller that handles WSS requests regarding games.
class WssGameController {
  /// Instance of `DatabaseService`.
  final DatabaseService _databaseService;

  /// Constructs new `AuthController` object.
  WssGameController({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService.instance;

  /// Handles connection to socket on which all game events are broadcasted.
  /// This socket is only valid for public games.
  ///
  /// The response is 400 in case of bad request (cannot be upgraded to WSS),
  /// 404 in case the game with [gameId] is not found or a corresponding stream
  /// controller is not found. Otherwise, the request is upgraded and connected
  /// to event stream.
  Future<void> handleConnectOnBroadcastSocket(
    HttpRequest request, {
    required String gameId,
  }) async {
    final bool isValidUpgradeRequest =
        WebSocketTransformer.isUpgradeRequest(request);
    if (!isValidUpgradeRequest) return respondWithBadRequest(request);

    final bool gameWithIdExists = memory.gamesInProgress.containsKey(gameId);
    if (!gameWithIdExists) return respondWithNotFound(request);

    if (!memory.gameBroadcastStreamControllers.containsKey(gameId)) {
      return respondWithNotFound(request);
    }

    final WebSocket socket = await WebSocketTransformer.upgrade(request);
    socket.addStream(memory.gameBroadcastStreamControllers[gameId]!.stream
        .map<String>(
            (InsanichessGameEvent event) => jsonEncode(event.toJson())));
    memory.gameBroadcastConnectedSockets[gameId]!.add(socket);
  }

  /// Handles connection on white player's socket. Over this socket, white can
  /// send events for actions he performed and receive events for actions that
  /// his opponent (black player) peformed.
  ///
  /// The response is 500 in case of internal server error, 400 in case of bad
  /// request (cannot be upgraded to WSS or if there is already an open
  /// connection for white player), 401 in case of bad JWT token, 404 in case
  /// game of [gameId] is not found, 403 in case the user connecting to this
  /// socket is not the white player, otherwise a connection is established.
  Future<void> handleConnectOnWhitePlayerSocket(
    HttpRequest request, {
    required String gameId,
  }) async {
    final bool isValidUpgradeRequest =
        WebSocketTransformer.isUpgradeRequest(request);
    if (!isValidUpgradeRequest) return respondWithBadRequest(request);

    final bool gameWithIdExists = memory.gamesInProgress.containsKey(gameId);
    if (!gameWithIdExists) return respondWithNotFound(request);

    final bool alreadyConnected = memory.gameSocketsWhite.containsKey(gameId);
    if (alreadyConnected) return respondWithBadRequest(request);

    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    final Either<DatabaseFailure, InsanichessPlayer?> playerOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerOrFailure.isError() || !playerOrFailure.hasValue()) {
      return respondWithInternalServerError(request);
    }

    if (memory.gamesInProgress[gameId]!.whitePlayer != playerOrFailure.value!) {
      return respondWithForbidden(request);
    }

    final WebSocket socket = await WebSocketTransformer.upgrade(request);
    memory.gameSocketStreamSubscriptionsWhite[gameId] =
        socket.listen((event) {});
    memory.gameSocketsWhite[gameId] = socket;
  }

  /// Handles connection on white player's socket. Over this socket, white can
  /// send events for actions he performed and receive events for actions that
  /// his opponent (black player) peformed.
  ///
  /// The response is 500 in case of internal server error, 400 in case of bad
  /// request (cannot be upgraded to WSS or if there is already an open
  /// connection for white player), 401 in case of bad JWT token, 404 in case
  /// game of [gameId] is not found, 403 in case the user connecting to this
  /// socket is not the white player, otherwise a connection is established.
  Future<void> handleConnectOnBlackPlayerSocket(
    HttpRequest request, {
    required String gameId,
  }) async {
    final bool isValidUpgradeRequest =
        WebSocketTransformer.isUpgradeRequest(request);
    if (!isValidUpgradeRequest) return respondWithBadRequest(request);

    final bool gameWithIdExists = memory.gamesInProgress.containsKey(gameId);
    if (!gameWithIdExists) return respondWithNotFound(request);

    final bool alreadyConnected = memory.gameSocketsBlack.containsKey(gameId);
    if (alreadyConnected) return respondWithBadRequest(request);

    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    final Either<DatabaseFailure, InsanichessPlayer?> playerOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerOrFailure.isError() || !playerOrFailure.hasValue()) {
      return respondWithInternalServerError(request);
    }

    if (memory.gamesInProgress[gameId]!.blackPlayer != playerOrFailure.value!) {
      return respondWithForbidden(request);
    }

    final WebSocket socket = await WebSocketTransformer.upgrade(request);
    memory.gameSocketStreamSubscriptionsBlack[gameId] =
        socket.listen((event) {});
    memory.gameSocketsBlack[gameId] = socket;
  }
}
