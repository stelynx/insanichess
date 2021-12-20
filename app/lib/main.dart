import 'package:flutter/cupertino.dart';

import 'router/router.dart';
import 'router/routes.dart';
import 'util/logger.dart';

void main() {
  Logger();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Insanichess',
      initialRoute: ICRoute.home,
      onGenerateRoute: ICRouter.onGenerateRoute,
    );
  }
}
