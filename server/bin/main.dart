import 'package:insanichess_server/insanichess_server.dart';
import 'package:insanichess_server/src/config/db.dart';
import 'package:insanichess_server/src/router/ic_router.dart';
import 'package:insanichess_server/src/services/database/database_service.dart';
import 'package:insanichess_server/src/util/logger.dart';

Future<void> main() async {
  Logger();

  final DbConfig dbConfig = DbConfig(
    host: 'localhost',
    port: 5432,
    databaseName: 'insanichess_db',
    username: 'insanichess_admin',
    password: 'demo_pass',
  );
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
