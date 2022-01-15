import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../util/functions/default_responses.dart';
import '../router_interface.dart';
import 'auth/auth.dart';
import 'challenge/challenge.dart';
import 'player/player.dart';

/// Router that handles requests on `/ICServerRouter.api`.
class ApiRouter implements RouterInterface {
  /// Router that handles auth requests.
  final AuthRouter _authRouter;

  /// Router that handles requests regarding players.
  final PlayerRouter _playerRouter;

  /// Router that handles requests for games.
  final ChallengeRouter _challengeRouter;

  /// Constructs new `ApiRouter` with given [authRouter].
  ApiRouter({
    AuthRouter? authRouter,
    PlayerRouter? playerRouter,
    ChallengeRouter? challengeRouter,
  })  : _authRouter = authRouter ?? AuthRouter(),
        _playerRouter = playerRouter ?? PlayerRouter(),
        _challengeRouter = challengeRouter ?? ChallengeRouter();

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length <= 1) {
      return respondWithBadRequest(request);
    }

    switch (pathSegments[1]) {
      case ICServerRoute.apiAuth:
        return await _authRouter.handle(request);
      case ICServerRoute.apiPlayer:
        return await _playerRouter.handle(request);
      case ICServerRoute.apiChallenge:
        return await _challengeRouter.handle(request);
      default:
        return respondWithBadRequest(request);
    }
  }
}
