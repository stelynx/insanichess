import 'package:flutter/cupertino.dart';

import '../screens/game.dart';
import '../screens/game_history.dart';
import '../screens/home.dart';
import '../screens/player_registration.dart';
import '../screens/rules.dart';
import '../screens/settings/otb_settings.dart';
import '../screens/settings/settings.dart';
import '../screens/sign_in.dart';
import '../screens/splash.dart';
import '../util/logger.dart';
import 'routes.dart';

/// Provides [onGenerateRoute] function and stores current topmost route.
abstract class ICRouter {
  static final List<String> _routeHistory = <String>[];

  static bool isCurrentRoute(String routeName) =>
      _routeHistory.last == routeName;

  /// Pops the route and updates [routeHistory].
  static void pop(BuildContext context) {
    _routeHistory.removeLast();
    Navigator.of(context).pop();
  }

  /// Pops the route and updates [routeHistory].
  static void popUntil(BuildContext context, bool Function() until) {
    while (!until()) {
      _routeHistory.removeLast();
      Navigator.of(context).pop();
    }
  }

  /// Pushes the named route with [name] and [args] and updates [routeHistory].
  static Future<void> pushNamed(
    BuildContext context,
    String name, {
    Object? arguments,
  }) async {
    _routeHistory.add(name);
    return await Navigator.of(context)
        .pushNamed<void>(name, arguments: arguments);
  }

  /// Transforms [settings] into corresponding route.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Logger.instance.info(
      'SmolltarRouter.onGenerateRoute',
      'pushing route ${settings.name}',
    );

    switch (settings.name) {
      case ICRoute.initial:
        return CupertinoPageRoute(builder: (context) => const SplashScreen());
      case ICRoute.signIn:
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => const SignInScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      case ICRoute.playerRegistration:
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => const PlayerRegistrationScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      case ICRoute.home:
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      case ICRoute.game:
        return CupertinoPageRoute(
          builder: (context) => GameScreen(
            args: settings.arguments as GameScreenArgs,
          ),
        );
      case ICRoute.gameHistory:
        return CupertinoPageRoute(
          builder: (context) => const GameHistoryScreen(),
        );
      case ICRoute.rules:
        return CupertinoPageRoute(builder: (context) => const RulesScreen());
      case ICRoute.settings:
        return CupertinoPageRoute(builder: (context) => const SettingsScreen());
      case ICRoute.settingsOtb:
        return CupertinoPageRoute(
            builder: (context) => OtbSettingsScreen(
                  args: settings.arguments as OtbSettingsScreenArgs,
                ));
    }
  }
}
