import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../controller/api/settings/settings.dart';
import '../../../services/database/database_service.dart';
import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';

/// Router that handles requests on
/// `/ICServerRoute.api/ICServerRoute.apiSettings`.
class SettingsRouter implements RouterInterface {
  /// The corresponding controller.
  final SettingsController _settingsController;

  /// Constructs new `SettingsRouter` object with given [playerController].
  SettingsRouter({SettingsController? settingsController})
      : _settingsController = settingsController ??
            SettingsController(databaseService: DatabaseService.instance);

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length == 2) {
      switch (pathSegments[1]) {
        case ICServerRoute.apiSettings:
          if (request.method == 'PATCH') {
            return await _settingsController.handlePatchSettings(request);
          }
          return respondWithBadRequest(request);
        default:
          return respondWithBadRequest(request);
      }
    }
  }
}
