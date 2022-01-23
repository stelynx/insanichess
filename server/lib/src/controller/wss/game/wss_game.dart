import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:pausable_timer/pausable_timer.dart';

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

    print(memory.gamesInProgress);

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
    memory.gameSocketStreamSubscriptionsWhite[gameId] = socket.listen(
      (event) => _respondToEventOnPlayerSocket(
        event,
        insanichess.PieceColor.white,
        gameId: gameId,
      ),
    );
    socket.addStream(memory.gameWhiteStreamControllers[gameId]!.stream
        .map<String>(
            (InsanichessGameEvent event) => jsonEncode(event.toJson())));
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
    memory.gameSocketStreamSubscriptionsBlack[gameId] = socket.listen(
      (event) => _respondToEventOnPlayerSocket(
          event, insanichess.PieceColor.black,
          gameId: gameId),
    );
    socket.addStream(memory.gameBlackStreamControllers[gameId]!.stream
        .map<String>(
            (InsanichessGameEvent event) => jsonEncode(event.toJson())));
    memory.gameSocketsBlack[gameId] = socket;
  }

  // Helpers

  /// Handles [event] sent by [player].
  ///
  /// This method updates the game state, and if the update was successful it
  /// forwards the event to broadcast stream and opponent's socket. If the event
  /// is received after the game has already ended, it is immediately ignored.
  ///
  /// In case the [InsanichessLiveGame.playerOfferedDraw] or
  /// [InsanichessLiveGame.playerRequestedUndo] are not null and the same event
  /// comes from the opponent, it is treated as accepting (this can happen if
  /// opponent issued the same request before the one of the opponent reached
  /// him and was processed by his device).
  ///
  /// After each [event] is received, the status of the game is checked. In case
  /// the game is over, corresponding web sockets and streams are closed. The
  /// game is also written into the database.
  ///
  /// Every valid [MovePlayedGameEvent] cancels both undo and draw requests.
  ///
  /// Event that is not valid in current game state or could not be parsed is
  /// simply ignored for performance reasons.
  void _respondToEventOnPlayerSocket(
    dynamic event,
    insanichess.PieceColor player, {
    required String gameId,
  }) {
    // This is used in case the received event is a move event. We initialize it
    // here to not take into account the processing.
    final DateTime timeOfMove = DateTime.now();

    if (memory.gamesInProgress[gameId]?.isGameOver ?? true) return;

    if (event is! String ||
        !memory.gameBroadcastStreamControllers.containsKey(gameId)) return;

    final InsanichessGameEvent gameEvent;
    try {
      gameEvent = InsanichessGameEvent.fromJson(jsonDecode(event));
    } catch (_) {
      return;
    }

    try {
      final InsanichessGameEvent? processedGameEvent;
      switch (gameEvent.type) {
        case GameEventType.movePlayed:
          // Check that a player who sent this event is the same as the player
          // that is currently on turn. This is enough, because the game logic
          // will handle the rest. This will need to change once we add premoves.
          // We also pause the timer for flagging while checking if move is
          // legal. In case it is not, we resume the timer. If the move is
          // legal, then the timer is re-set right before sending the move event
          // to the opponent.
          final MovePlayedGameEvent movePlayedGameEvent =
              gameEvent as MovePlayedGameEvent;
          if (player == memory.gamesInProgress[gameId]!.playerOnTurn) {
            // Pause the timer while processing.
            memory.gameTimerPlayerFlagged[gameId]!.pause();

            // This needs to be remembered because calling `game.move(m)` will
            // change player on turn.
            final insanichess.PieceColor playerMakingMove =
                memory.gamesInProgress[gameId]!.playerOnTurn;

            // Make a move.
            final insanichess.PlayedMove? move =
                memory.gamesInProgress[gameId]!.move(movePlayedGameEvent.move);
            if (move == null) {
              memory.gameTimerPlayerFlagged[gameId]!.start();
              processedGameEvent = null;
              break;
            }

            final Duration moveDuration;
            if (memory.gamesInProgress[gameId]!.timeOfLastMove == null) {
              // This only happens when white player makes his first move.
              moveDuration = Duration.zero;
            } else {
              moveDuration = timeOfMove
                  .difference(memory.gamesInProgress[gameId]!.timeOfLastMove!);
            }

            // Update time related values.
            memory.gamesInProgress[gameId]!.updateTime(
              moveDuration,
              playerMakingMove,
            );

            // "Decline" undo and draw requests.
            memory.gamesInProgress[gameId]!.playerOfferedDraw = null;
            memory.gamesInProgress[gameId]!.playerRequestedUndo = null;

            processedGameEvent = MovePlayedGameEvent(
              move: gameEvent.move,
              timeSpent: moveDuration,
              player: playerMakingMove,
            );
          } else {
            processedGameEvent = null;
          }
          break;

        case GameEventType.drawOffered:
          // If both players issued the draw offer, propagate this request into
          // draw offer accept.
          if (memory.gamesInProgress[gameId]!.playerOfferedDraw != null &&
              memory.gamesInProgress[gameId]!.playerOfferedDraw != player) {
            processedGameEvent = DrawOfferRespondedGameEvent(accept: true);
            memory.gamesInProgress[gameId]!.draw();
          }
          // If this request was reissued, ignore it.
          else if (memory.gamesInProgress[gameId]!.playerOfferedDraw ==
              player) {
            processedGameEvent = null;
          } else {
            processedGameEvent = gameEvent;
            memory.gamesInProgress[gameId]!.playerOfferedDraw = player;
          }
          break;

        case GameEventType.drawOfferCancelled:
          // This event is valid only if the player that cancelled the draw offer
          // is the one that previously asked for it.
          if (memory.gamesInProgress[gameId]!.playerOfferedDraw == player) {
            memory.gamesInProgress[gameId]!.playerOfferedDraw = null;
            processedGameEvent = gameEvent;
          } else {
            processedGameEvent = null;
          }
          break;

        case GameEventType.drawOfferResponded:
          final DrawOfferRespondedGameEvent drawOfferRespondedGameEvent =
              gameEvent as DrawOfferRespondedGameEvent;
          // Draw offer can only be accepted by the opponent.
          if (memory.gamesInProgress[gameId]!.playerOfferedDraw != null &&
              memory.gamesInProgress[gameId]!.playerOfferedDraw != player) {
            if (drawOfferRespondedGameEvent.accept) {
              memory.gamesInProgress[gameId]!.draw();
            }
            processedGameEvent = drawOfferRespondedGameEvent;
          } else {
            processedGameEvent = null;
          }
          memory.gamesInProgress[gameId]!.playerOfferedDraw = null;
          break;

        case GameEventType.undoRequested:
          // If undo is not allowed, ignore event. We only need to check for this
          // here, in case of undo request response, the player requested undo
          // is null.
          if (!memory.gamesInProgress[gameId]!.undoAllowed) {
            processedGameEvent = null;
            break;
          }
          // Ignore undo request if not possible to undo.
          if (!memory.gamesInProgress[gameId]!.canUndo) {
            processedGameEvent = null;
            break;
          }
          // If both players issued the undo request, propagate this request into
          // undo request accept.
          if (memory.gamesInProgress[gameId]!.playerRequestedUndo != null &&
              memory.gamesInProgress[gameId]!.playerRequestedUndo != player) {
            memory.gamesInProgress[gameId]!.undo();
            memory.gamesInProgress[gameId]!.playerRequestedUndo = null;
            processedGameEvent = UndoRespondedGameEvent(accept: true);
          }
          // If this request was reissued, ignore it.
          else if (memory.gamesInProgress[gameId]!.playerRequestedUndo ==
              player) {
            processedGameEvent = null;
          } else {
            memory.gamesInProgress[gameId]!.playerRequestedUndo = player;
            processedGameEvent = gameEvent;
          }
          break;

        case GameEventType.undoCancelled:
          // This event is valid only if the player that cancelled the undo is the
          // one that previously asked for it.
          if (memory.gamesInProgress[gameId]!.playerRequestedUndo == player) {
            memory.gamesInProgress[gameId]!.playerRequestedUndo = null;
            processedGameEvent = gameEvent;
          } else {
            processedGameEvent = null;
          }
          break;

        case GameEventType.undoRequestResponded:
          // This event is valid if the player responding is not the player that
          // issued the request.
          if (memory.gamesInProgress[gameId]!.playerRequestedUndo != null &&
              memory.gamesInProgress[gameId]!.playerRequestedUndo != player) {
            memory.gamesInProgress[gameId]!.undo();
            memory.gamesInProgress[gameId]!.playerRequestedUndo = null;
            processedGameEvent = gameEvent;
          } else {
            processedGameEvent = null;
          }
          break;

        case GameEventType.resigned:
          if (player == insanichess.PieceColor.white) {
            memory.gamesInProgress[gameId]!.whiteResigned();
          } else {
            memory.gamesInProgress[gameId]!.blackResigned();
          }
          processedGameEvent = ResignedGameEvent(player: player);
          break;

        case GameEventType.disbanded:
          // Server can never receive this event, however clients will need to
          // be able to react to this event (this part will be moved to SDK in
          // future), therefore we just pass this event through doing nothing,
          // instead of setting it to `null`.
          processedGameEvent = gameEvent;
          break;

        case GameEventType.flagged:
          // Server can never receive this event, however clients will need to
          // be able to react to this event (this part will be moved to SDK in
          // future), therefore we just pass this event through doing nothing,
          // instead of setting it to `null`.
          processedGameEvent = gameEvent;
          break;
      }

      // If the event had no effect on game, ignore it.
      if (processedGameEvent == null) return;

      // First, set the flagging timer and send the processed game event on the
      // players' sockets ...
      if (player == insanichess.PieceColor.white) {
        memory.gameBlackStreamControllers[gameId]!.add(processedGameEvent);

        if (processedGameEvent is MovePlayedGameEvent) {
          memory.gameTimerPlayerFlagged[gameId]!.cancel();
          memory.gameTimerPlayerFlagged[gameId] = PausableTimer(
            memory.gamesInProgress[gameId]!.remainingTimeBlack,
            () => _onPlayerFlagged(gameId),
          );
          memory.gameTimerPlayerFlagged[gameId]!.start();
          memory.gameWhiteStreamControllers[gameId]!.add(processedGameEvent);
        }
      } else {
        memory.gameWhiteStreamControllers[gameId]!.add(processedGameEvent);

        if (processedGameEvent is MovePlayedGameEvent) {
          memory.gameTimerPlayerFlagged[gameId]!.cancel();
          memory.gameTimerPlayerFlagged[gameId] = PausableTimer(
            memory.gamesInProgress[gameId]!.remainingTimeWhite,
            () => _onPlayerFlagged(gameId),
          );
          memory.gameTimerPlayerFlagged[gameId]!.start();
          memory.gameBlackStreamControllers[gameId]!.add(processedGameEvent);
        }
      }
      // Sent back to both clients so they can sync their clocks.

      // ... then broadcast the event if it needs to be broadcasted.
      if (processedGameEvent.isBroadcasted) {
        memory.gameBroadcastStreamControllers[gameId]!.add(processedGameEvent);
      }
    } on RangeError catch (_) {
      // In case of moving outside the board.
    }

    if (memory.gamesInProgress[gameId]!.isGameOver) {
      _onGameEnded(gameId);
    }
  }

  /// Completes the game by closing all open stream controllers, cancelling
  /// subscriptions and closing sockets. The game is also written to the
  /// database if status is not disbanded.
  Future<void> _onGameEnded(String gameId) async {
    // Write game to database and perform cleanup even if saving failed.
    await _databaseService.saveGame(memory.gamesInProgress[gameId]!);

    await memory.cleanUpAfterGame(gameId);
  }

  /// Updates game state that a player f
  Future<void> _onPlayerFlagged(String gameId) async {
    // This should never happen but let's keep it here just in case.
    if (!memory.gamesInProgress[gameId]!.inProgress) return;

    memory.gamesInProgress[gameId]!.flagged();

    // Notify listeners about the flagging.
    final FlaggedGameEvent flaggedGameEvent =
        FlaggedGameEvent(player: memory.gamesInProgress[gameId]!.playerOnTurn);
    memory.gameWhiteStreamControllers[gameId]!.add(flaggedGameEvent);
    memory.gameBlackStreamControllers[gameId]!.add(flaggedGameEvent);
    memory.gameBroadcastStreamControllers[gameId]!.add(flaggedGameEvent);

    await _onGameEnded(gameId);
  }
}
