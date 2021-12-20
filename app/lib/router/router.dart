import 'package:flutter/cupertino.dart';

import '../screens/home.dart';
import '../screens/splash.dart';
import '../util/logger.dart';
import 'routes.dart';

abstract class ICRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Logger.instance.info(
      'SmolltarRouter.onGenerateRoute',
      'pushing route ${settings.name}',
    );

    switch (settings.name) {
      case ICRoute.initial:
        return CupertinoPageRoute(builder: (context) => const SplashScreen());
      case ICRoute.home:
        return CupertinoPageRoute(builder: (context) => const HomeScreen());
    }
  }
}
