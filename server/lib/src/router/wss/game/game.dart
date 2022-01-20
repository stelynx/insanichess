import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../controller/wss/game/wss_game.dart';
import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';

/// Router that handles requests on `/ICServerRoute.wss/ICServerRoute.wssGame`.
class WssGameRouter implements RouterInterface {
  final WssGameController _wssGameController;

  /// Constructs new `WssGameRouter` with given [wssGameController].
  WssGameRouter({WssGameController? wssGameController})
      : _wssGameController = wssGameController ?? WssGameController();

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length <= 2) {
      return respondWithBadRequest(request);
    }

    // This is the request for socket that streams all game events.
    if (pathSegments.length == 3) {
      return await _wssGameController.handleConnectOnBroadcastSocket(
        request,
        gameId: pathSegments[2],
      );
    }

    switch (pathSegments[3]) {
      case ICServerRoute.wssGameWhite:
        return await _wssGameController.handleConnectOnWhitePlayerSocket(
          request,
          gameId: pathSegments[2],
        );
      case ICServerRoute.wssGameBlack:
        return await _wssGameController.handleConnectOnBlackPlayerSocket(
          request,
          gameId: pathSegments[2],
        );
      default:
        return respondWithBadRequest(request);
    }
  }
}
