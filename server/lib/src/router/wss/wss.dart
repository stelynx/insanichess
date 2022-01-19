import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../util/functions/default_responses.dart';
import '../router_interface.dart';
import 'game/game.dart';

/// Router that handles requests on `/ICServerRouter.wss`.
class WssRouter implements RouterInterface {
  /// Roter that handles WSS requests for games.
  final WssGameRouter _wssGameRouter;

  /// Constructs new `WssRouter` with given [wssGameController].
  WssRouter({
    WssGameRouter? wssGameRouter,
  }) : _wssGameRouter = wssGameRouter ?? WssGameRouter();

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length <= 1) {
      return respondWithBadRequest(request);
    }

    switch (pathSegments[1]) {
      case ICServerRoute.wssGame:
        return await _wssGameRouter.handle(request);
      default:
        return respondWithBadRequest(request);
    }
  }
}
