import 'dart:async';
import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

/// Globally accessible memory.
final Memory memory = Memory();

/// In-memory storage for server.
class Memory {
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
}
