import 'dart:io';

import '../../../controller/api/game/live_game.dart';
import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';

/// Router that handles requests on
/// `/ICServerRoute.api/ICServerRoute.apiGame/ICServerRoute.apiGameLive`.
class LiveGameRouter implements RouterInterface {
  final LiveGameController _liveGameController;

  /// Constructs new [LiveGameRouter] object with given [liveGameController].
  const LiveGameRouter({LiveGameController? liveGameController})
      : _liveGameController = liveGameController ?? const LiveGameController();

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length < 4) {
      return respondWithBadRequest(request);
    }

    if (request.method == 'GET') {
      return await _liveGameController.handleGetLiveGameDetails(
        request,
        gameId: pathSegments.last,
      );
    }

    return respondWithBadRequest(request);
  }
}
