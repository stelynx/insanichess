import 'package:flutter/cupertino.dart';

import 'router/router.dart';
import 'router/routes.dart';
import 'services/local_storage_service.dart';
import 'util/logger.dart';

void main() {
  Logger();

  LocalStorageService();

  runApp(const InsanichessApp());
}

class InsanichessApp extends StatelessWidget {
  const InsanichessApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Insanichess',
      initialRoute: ICRoute.home,
      onGenerateRoute: ICRouter.onGenerateRoute,
    );
  }
}
