import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../controller/api/players/online_players.dart';
import '../../../services/database/database_service.dart';
import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';

/// Router that handles requests on
/// `/ICServerRoute.api/ICServerRoute.apiPlayers/ICServerRoute.apiPlayersOnline`.
class OnlinePlayersRouter implements RouterInterface {
  /// Main controller for handling requests.
  final OnlinePlayersController _onlinePlayersController;

  /// Constructs new [OnlinePlayersRouter] object with given
  /// [onlinePlayersController].
  OnlinePlayersRouter({OnlinePlayersController? onlinePlayersController})
      : _onlinePlayersController = onlinePlayersController ??
            OnlinePlayersController(databaseService: DatabaseService.instance);

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length == 3) {
      if (pathSegments[2] == ICServerRoute.apiPlayersOnline) {
        if (request.method == 'POST') {
          return await _onlinePlayersController
              .handleNotifyPlayerOnlineOffline(request);
        }
      }
    }

    if (pathSegments.length == 4) {
      if (pathSegments[3] == ICServerRoute.apiPlayersOnlineCount) {
        return _onlinePlayersController.handleGetNumberOfOnlinePlayers(request);
      }

      return respondWithBadRequest(request);
    }

    return respondWithBadRequest(request);
  }
}
