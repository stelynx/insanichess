import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../controller/api/game/game.dart';
import '../../../services/database/database_service.dart';
import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';

/// Router that handles requests on `/ICServerRoute.api/ICServerRoute.apiGame`.
class GameRouter implements RouterInterface {
  /// The corresponding controller.
  final GameController _gameController;

  /// Constructs new `GameRouter` object with given [gameController].
  GameRouter({GameController? gameController})
      : _gameController = gameController ??
            GameController(databaseService: DatabaseService.instance);

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length == 2) {
      switch (pathSegments[1]) {
        case ICServerRoute.apiGame:
          if (request.method == 'POST') {
            return await _gameController.handleCreateGame(request);
          }
          print('here2');
          return respondWithBadRequest(request);
        default:
          print('here1');
          return respondWithBadRequest(request);
      }
    }
  }
}
