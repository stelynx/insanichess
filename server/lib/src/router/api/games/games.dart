import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';
import 'live_games.dart';

/// Router that handles requests on `/ICServerRoute.api/ICServerRoute.apiGames`.
class GamesRouter implements RouterInterface {
  /// Router for handling requests for live games.
  final LiveGamesRouter _liveGamesRouter;

  /// Constructs new [GamesRouter] object with given [gamesController].
  const GamesRouter({LiveGamesRouter? liveGamesRouter})
      : _liveGamesRouter = liveGamesRouter ?? const LiveGamesRouter();

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length < 3) {
      return respondWithBadRequest(request);
    }

    if (pathSegments[2] == ICServerRoute.apiGamesLive) {
      return await _liveGamesRouter.handle(request);
    }

    return respondWithBadRequest(request);
  }
}
