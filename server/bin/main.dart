import 'package:insanichess_server/insanichess_server.dart';

Future<void> main() async {
  Logger();

  final DbConfig dbConfig = DbConfig.fromEnvironment();
  final DatabaseService databaseService =
      DatabaseService(logger: Logger.instance);
  await databaseService.initialize(config: dbConfig);

  final ICRouter router = ICRouter();

  final InsanichessServer server = InsanichessServer(
    logger: Logger.instance,
    router: router,
  );
  await server.start();
}
