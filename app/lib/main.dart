import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'bloc/global/global_bloc.dart';
import 'router/router.dart';
import 'router/routes.dart';
import 'services/auth_service.dart';
import 'services/local_storage_service.dart';
import 'style/theme.dart';
import 'util/logger.dart';

void main() {
  Logger();

  GlobalBloc();

  AuthService();
  LocalStorageService();

  runApp(const InsanichessApp());
}

class InsanichessApp extends StatelessWidget {
  const InsanichessApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return const CupertinoApp(
      title: 'Insanichess',
      initialRoute: ICRoute.initial,
      onGenerateRoute: ICRouter.onGenerateRoute,
      theme: icTheme,
    );
  }
}
