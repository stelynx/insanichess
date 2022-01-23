import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../util/functions/default_responses.dart';
import '../router_interface.dart';
import 'auth/auth.dart';
import 'challenge/challenge.dart';
import 'game/game.dart';
import 'player/player.dart';
import 'settings/settings.dart';

/// Router that handles requests on `/ICServerRouter.api`.
class ApiRouter implements RouterInterface {
  /// Router that handles auth requests.
  final AuthRouter _authRouter;

  /// Router that handles requests regarding players.
  final PlayerRouter _playerRouter;

  /// Router that handles requests for games.
  final ChallengeRouter _challengeRouter;

  /// Router that handles requests for settings.
  final SettingsRouter _settingsRouter;

  /// Router that handles requests for games.
  final GameRouter _gameRouter;

  /// Constructs new `ApiRouter` with given [authRouter], [playerRouter],
  /// [challengeRouter], [settingsRouter], and [gameRouter].
  ///
  /// If any of the routers are `null`, they are created with defaults.
  ApiRouter({
    AuthRouter? authRouter,
    PlayerRouter? playerRouter,
    ChallengeRouter? challengeRouter,
    SettingsRouter? settingsRouter,
    GameRouter? gameRouter,
  })  : _authRouter = authRouter ?? AuthRouter(),
        _playerRouter = playerRouter ?? PlayerRouter(),
        _challengeRouter = challengeRouter ?? ChallengeRouter(),
        _settingsRouter = settingsRouter ?? SettingsRouter(),
        _gameRouter = gameRouter ?? const GameRouter();

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
      case ICServerRoute.apiSettings:
        return await _settingsRouter.handle(request);
      case ICServerRoute.apiGame:
        return await _gameRouter.handle(request);
      default:
        return respondWithBadRequest(request);
    }
  }
}
