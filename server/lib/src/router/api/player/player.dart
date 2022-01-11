import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../controller/api/player/player.dart';
import '../../../services/database/database_service.dart';
import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';

/// Router that handles requests on `/ICServerRoute.api/ICServerRoute.apiPlayer`.
class PlayerRouter implements RouterInterface {
  /// The corresponding controller.
  final PlayerController _playerController;

  /// Constructs new `PlayerRouter` object with given [playerController].
  PlayerRouter({PlayerController? playerController})
      : _playerController = playerController ??
            PlayerController(databaseService: DatabaseService.instance);

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length == 2) {
      switch (pathSegments[1]) {
        case ICServerRoute.apiPlayer:
          if (request.method == 'POST') {
            return await _playerController.handleCreatePlayer(request);
          }
          return respondWithBadRequest(request);
        default:
          return respondWithBadRequest(request);
      }
    }
  }
}
