import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../util/functions/default_responses.dart';
import 'api/api.dart';
import 'router_interface.dart';

/// Router that handles requests on `/`.
class ICRouter implements RouterInterface {
  /// Router that handles API requests.
  final ApiRouter _apiRouter;

  /// Constructs new `ICRouter` object with given [apiRouter].
  ICRouter({ApiRouter? apiRouter}) : _apiRouter = apiRouter ?? ApiRouter();

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;
    if (pathSegments.isEmpty) {
      return respondWithBadRequest(request);
    }

    switch (pathSegments.first) {
      case ICServerRoute.api:
        return await _apiRouter.handle(request);
      default:
        return respondWithBadRequest(request);
    }
  }
}
