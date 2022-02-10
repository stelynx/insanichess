import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';
import 'online_players.dart';

/// Router that handles requests on
/// `/ICServerRoute.api/ICServerRoute.apiPlayers`.
class PlayersRouter implements RouterInterface {
  /// Router for handling requests about online players.
  final OnlinePlayersRouter _onlinePlayersRouter;

  /// Constructs new [PlayersRouter] object with given [onlinePlayersRouter].
  PlayersRouter({OnlinePlayersRouter? onlinePlayersRouter})
      : _onlinePlayersRouter = onlinePlayersRouter ?? OnlinePlayersRouter();

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length < 3) {
      return respondWithBadRequest(request);
    }

    if (pathSegments[2] == ICServerRoute.apiPlayersOnline) {
      return await _onlinePlayersRouter.handle(request);
    }

    return respondWithBadRequest(request);
  }
}
