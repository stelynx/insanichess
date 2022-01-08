import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../controller/api/auth/auth.dart';
import '../../../services/database/database_service.dart';
import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';

/// Router that handles requests on `/ICServerRoute.api/ICServerRoute.apiAuth`.
class AuthRouter implements RouterInterface {
  final AuthController _authController;

  AuthRouter({AuthController? authController})
      : _authController = authController ??
            AuthController(databaseService: DatabaseService.instance);

  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length <= 2) {
      return respondWithBadRequest(request);
    }

    switch (pathSegments[2]) {
      case ICServerRoute.apiAuthLogin:
        return _authController.handleLogin(request);
      default:
        return respondWithBadRequest(request);
    }
  }
}
