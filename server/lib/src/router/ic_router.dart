import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../util/functions/default_responses.dart';
import 'api/api.dart';
import 'router_interface.dart';
import 'wss/wss.dart';

/// Router that handles requests on `/`.
class ICRouter implements RouterInterface {
  /// Router that handles API requests.
  final ApiRouter _apiRouter;

  /// Router that handles WSS requests.
  final WssRouter _wssRouter;

  /// Constructs new `ICRouter` object with given [apiRouter].
  ICRouter({ApiRouter? apiRouter, WssRouter? wssRouter})
      : _apiRouter = apiRouter ?? ApiRouter(),
        _wssRouter = wssRouter ?? WssRouter();

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
      case ICServerRoute.wss:
        return await _wssRouter.handle(request);
      default:
        return respondWithBadRequest(request);
    }
  }
}
