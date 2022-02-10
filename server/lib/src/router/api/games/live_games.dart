import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../controller/api/games/live_games.dart';
import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';

/// Router that handles requests on
/// `/ICServerRoute.api/ICServerRoute.apiGames/ICServerRoute.apiGamesLive`.
class LiveGamesRouter implements RouterInterface {
  /// Main controller for handling requests.
  final LiveGamesController _liveGamesController;

  /// Constructs new [LiveGamesRouter] object with given [liveGamesController].
  const LiveGamesRouter({LiveGamesController? liveGamesController})
      : _liveGamesController =
            liveGamesController ?? const LiveGamesController();

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length < 4) {
      return respondWithBadRequest(request);
    }

    if (pathSegments[3] == ICServerRoute.apiGamesLiveCount) {
      return _liveGamesController.handleGetNumberOfGamesInProgress(request);
    }

    return respondWithBadRequest(request);
  }
}
