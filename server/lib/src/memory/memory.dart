import 'dart:async';
import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:pausable_timer/pausable_timer.dart';

/// Convenience getter for [Memory._instance].
///
/// Instead of providing `static Memory get instance => _instance` inside the
/// [Memory] class, we provide this global getter for the instance in order to
/// shorten the number of character a developer needs to type in order to access
/// the memory singleton object.
Memory get memory => Memory._instance;

/// In-memory storage for server.
///
/// This class is a singleton. Access it using getter [Memory.instance].
class Memory {
  /// Instance of this class.
  static final Memory _instance = Memory._();

  /// Private constructor for creating the only instance of this singleton.
  Memory._();

  /// List of currently opened challenges.
  ///
  /// A map from ids to corresponding challenges.
  final Map<String, InsanichessChallenge> openChallenges =
      <String, InsanichessChallenge>{};

  /// List of games currently in progress.
  ///
  /// A map from temporary ids to corresponding games. [InsanichessLiveGame]
  /// contains the id, however this implementation is purely for convenience and
  /// better performance when querying by id. Also, `InsanichessGame.id` is the
  /// id in database, not temporary id.
  final Map<String, InsanichessLiveGame> gamesInProgress =
      <String, InsanichessLiveGame>{};

  /// List of stream controllers for games currently in progress that broadcast
  /// game events.
  ///
  /// A map from temporary game ids to the corresponding event streams.
  final Map<String, StreamController<InsanichessGameEvent>>
      gameBroadcastStreamControllers =
      <String, StreamController<InsanichessGameEvent>>{};

  /// List of currently opened sockets listening to [gameBroadcastStreams].
  ///
  /// A map from temporary game ids to the list of opened sockets for the
  /// corresponding game id.
  final Map<String, List<WebSocket>> gameBroadcastConnectedSockets =
      <String, List<WebSocket>>{};

  /// List of currently opened websockets for listening events issued by white.
  final Map<String, WebSocket> gameSocketsWhite = <String, WebSocket>{};

  /// List of currently opened websockets for listening events issued by black.
  final Map<String, WebSocket> gameSocketsBlack = <String, WebSocket>{};

  /// List of stream controllers for games currently in progress that send
  /// events to white player's socket.
  ///
  /// A map from temporary game ids to the corresponding event streams.
  final Map<String, StreamController<InsanichessGameEvent>>
      gameWhiteStreamControllers =
      <String, StreamController<InsanichessGameEvent>>{};

  /// List of stream controllers for games currently in progress that send
  /// events to black player's socket.
  ///
  /// A map from temporary game ids to the corresponding event streams.
  final Map<String, StreamController<InsanichessGameEvent>>
      gameBlackStreamControllers =
      <String, StreamController<InsanichessGameEvent>>{};

  /// List of currently opened stream subscriptions for listening events issued
  /// on corresponding socket by white.
  final Map<String, StreamSubscription> gameSocketStreamSubscriptionsWhite =
      <String, StreamSubscription>{};

  /// List of currently opened stream subscriptions for listening events issued
  /// on corresponding socket by black.
  final Map<String, StreamSubscription> gameSocketStreamSubscriptionsBlack =
      <String, StreamSubscription>{};

  /// List of timers that set the game as flagged by the player currently on
  /// turn. When a game is created, this timer is set to
  /// `Config.secondsWhiteForFirstMove` seconds. If white player does not make a
  /// move, the game is disbanded. After each move, a server cancels the current
  /// timer and creates new one with the time a player on turn has remaining.
  final Map<String, PausableTimer> gameTimerPlayerFlagged =
      <String, PausableTimer>{};

  /// Closes, cancels and deletes every in-memory held data for the game with id
  /// [gameId].
  ///
  /// If the game needs to saved in the database, it should be saved before this
  /// method is called.
  Future<void> cleanUpAfterGame(String gameId) async {
    // Cancel and delete timer for flagging.
    gameTimerPlayerFlagged[gameId]?.cancel();
    gameTimerPlayerFlagged.remove(gameId);

    // Cancel and delete subscriptions to players' sockets.
    await gameSocketStreamSubscriptionsWhite[gameId]?.cancel();
    await gameSocketStreamSubscriptionsBlack[gameId]?.cancel();
    gameSocketStreamSubscriptionsWhite.remove(gameId);
    gameSocketStreamSubscriptionsBlack.remove(gameId);

    // Close and delete stream controllers for player events.
    if (gameWhiteStreamControllers[gameId]!.hasListener) {
      await gameWhiteStreamControllers[gameId]!.sink.close();
      await gameWhiteStreamControllers[gameId]?.close();
    }
    if (gameBlackStreamControllers[gameId]!.hasListener) {
      await gameBlackStreamControllers[gameId]!.sink.close();
      await gameBlackStreamControllers[gameId]?.close();
    }
    gameWhiteStreamControllers.remove(gameId);
    gameBlackStreamControllers.remove(gameId);

    // Close and delete players sockets.
    await gameSocketsWhite[gameId]?.close(WebSocketStatus.normalClosure);
    await gameSocketsBlack[gameId]?.close(WebSocketStatus.normalClosure);
    gameSocketsWhite.remove(gameId);
    gameSocketsBlack.remove(gameId);

    // Close and delete broadcast stream controller.
    await gameBroadcastStreamControllers[gameId]!.sink.close();
    await gameBroadcastStreamControllers[gameId]!.close();
    gameBroadcastStreamControllers.remove(gameId);

    // Close and delete sockets connected to broadcast stream.
    for (final WebSocket socket in gameBroadcastConnectedSockets[gameId]!) {
      await socket.close(WebSocketStatus.normalClosure);
    }
    gameBroadcastConnectedSockets.remove(gameId);

    // Remove the game.
    gamesInProgress.remove(gameId);
  }
}
