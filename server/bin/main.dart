import 'package:insanichess_server/insanichess_server.dart';
import 'package:insanichess_server/src/util/logger.dart';

Future<void> main() async {
  Logger();

  final InsanichessServer server = InsanichessServer(logger: Logger.instance);
  await server.create();
}
