import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'bloc/connectivity/connectivity_bloc.dart';
import 'bloc/global/global_bloc.dart';
import 'router/router.dart';
import 'router/routes.dart';
import 'services/auth_service.dart';
import 'services/backend_service.dart';
import 'services/connectivity_service.dart';
import 'services/http_service.dart';
import 'services/local_storage_service.dart';
import 'services/wss_service.dart';
import 'style/theme.dart';
import 'util/logger.dart';

void main() {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Logger logger = Logger();

  final HttpService httpService = HttpService();
  AuthService(httpService: httpService);
  BackendService(httpService: httpService);
  final ConnectivityService connectivityService = ConnectivityService();
  WssService();
  LocalStorageService();

  GlobalBloc(logger: logger);
  ConnectivityBloc(
    connectivityService: connectivityService,
    httpService: httpService,
    navigatorKey: navigatorKey,
  );

  runApp(InsanichessApp(navigatorKey: navigatorKey));
}

class InsanichessApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const InsanichessApp({
    Key? key,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return CupertinoApp(
      title: 'Insanichess',
      initialRoute: ICRoute.initial,
      onGenerateRoute: ICRouter.onGenerateRoute,
      theme: icTheme,
      navigatorKey: navigatorKey,
    );
  }
}
