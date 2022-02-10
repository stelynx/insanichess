import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../util/functions/default_responses.dart';
import '../router_interface.dart';
import 'auth/auth.dart';
import 'challenge/challenge.dart';
import 'game/game.dart';
import 'games/games.dart';
import 'player/player.dart';
import 'players/players.dart';
import 'settings/settings.dart';

/// Router that handles requests on `/ICServerRouter.api`.
class ApiRouter implements RouterInterface {
  /// Router that handles auth requests.
  final AuthRouter _authRouter;

  /// Router that handles requests for single player.
  final PlayerRouter _playerRouter;

  /// Router that handles requests regarding players.
  final PlayersRouter _playersRouter;

  /// Router that handles requests for games.
  final ChallengeRouter _challengeRouter;

  /// Router that handles requests for settings.
  final SettingsRouter _settingsRouter;

  /// Router that handles requests for a single game.
  final GameRouter _gameRouter;

  /// Router that handles requests for games.
  final GamesRouter _gamesRouter;

  /// Constructs new `ApiRouter` with given [authRouter], [playerRouter],
  /// [challengeRouter], [settingsRouter], and [gameRouter].
  ///
  /// If any of the routers are `null`, they are created with defaults.
  ApiRouter({
    AuthRouter? authRouter,
    PlayerRouter? playerRouter,
    PlayersRouter? playersRouter,
    ChallengeRouter? challengeRouter,
    SettingsRouter? settingsRouter,
    GameRouter? gameRouter,
    GamesRouter? gamesRouter,
  })  : _authRouter = authRouter ?? AuthRouter(),
        _playerRouter = playerRouter ?? PlayerRouter(),
        _playersRouter = playersRouter ?? PlayersRouter(),
        _challengeRouter = challengeRouter ?? ChallengeRouter(),
        _settingsRouter = settingsRouter ?? SettingsRouter(),
        _gameRouter = gameRouter ?? const GameRouter(),
        _gamesRouter = gamesRouter ?? const GamesRouter();

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
      case ICServerRoute.apiPlayers:
        return await _playersRouter.handle(request);
      case ICServerRoute.apiChallenge:
        return await _challengeRouter.handle(request);
      case ICServerRoute.apiSettings:
        return await _settingsRouter.handle(request);
      case ICServerRoute.apiGame:
        return await _gameRouter.handle(request);
      case ICServerRoute.apiGames:
        return await _gamesRouter.handle(request);
      default:
        return respondWithBadRequest(request);
    }
  }
}
