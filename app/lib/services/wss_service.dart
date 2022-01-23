import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../util/either.dart';
import '../util/failures/backend_failure.dart';
import '../util/functions/auth_header_value.dart';
import '../util/functions/uri_for_path.dart';
import '../util/logger.dart';

class WssService {
  static WssService? _instance;
  static WssService get instance => _instance!;

  WssService._();

  factory WssService() {
    if (_instance != null) {
      throw StateError('WssService already created');
    }

    _instance = WssService._();
    return _instance!;
  }

  WebSocket? _playerSocket;

  Future<Either<BackendFailure, StreamSubscription<InsanichessGameEvent>>>
      connectToPlayerSocket({
    required String gameId,
    required insanichess.PieceColor color,
    required void Function(InsanichessGameEvent) onEventReceived,
  }) async {
    try {
      Logger.instance.debug(
        'WssService.connectToPlayerSocket',
        'connect to ${color.toJson()} socket for $gameId',
      );

      // Connect to socket.
      final String socketPath = uriForPath(
        [
          ICServerRoute.wss,
          ICServerRoute.wssGame,
          gameId,
          color == insanichess.PieceColor.white ? 'white' : 'black',
        ],
        isWss: true,
      ).toString();
      _playerSocket = await WebSocket.connect(
        socketPath,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: authHeaderValue(),
        },
      );

      // Create and return subscription for opponent's events.
      final StreamSubscription<InsanichessGameEvent> subscription =
          _playerSocket!
              .map<InsanichessGameEvent>(
                  (event) => InsanichessGameEvent.fromJson(jsonDecode(event)))
              .listen(onEventReceived);

      Logger.instance.debug(
        'WssService.connectToPlayerSocket',
        'connected to ${color.toJson()} socket for $gameId',
      );
      return value(subscription);
    } catch (e) {
      Logger.instance.error('WssService.connectToPlayerSocket', e);
      return error(const UnknownBackendFailure());
    }
  }

  Either<BackendFailure, void> addEventToPlayerSocket(
    InsanichessGameEvent gameEvent,
  ) {
    try {
      _playerSocket!.add(jsonEncode(gameEvent.toJson()));
      return value(null);
    } catch (_) {
      return error(const UnknownBackendFailure());
    }
  }
}
