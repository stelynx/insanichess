import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';
import 'live_game.dart';

/// Router that handles requests on `/ICServerRoute.api/ICServerRoute.apiGame`.
class GameRouter implements RouterInterface {
  /// Requests for live games are forwarded to this router.
  final LiveGameRouter _liveGameRouter;

  /// Constructs new [GameRouter] object with given [liveGameRouter].
  const GameRouter({LiveGameRouter? liveGameRouter})
      : _liveGameRouter = liveGameRouter ?? const LiveGameRouter();

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length < 3) {
      return respondWithBadRequest(request);
    }

    if (pathSegments[2] == ICServerRoute.apiGameLive) {
      return await _liveGameRouter.handle(request);
    }

    return respondWithBadRequest(request);
  }
}
