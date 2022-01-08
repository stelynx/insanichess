import 'dart:io';

import 'router/ic_router.dart';
import 'util/logger.dart';

class InsanichessServer {
  final Logger _logger;
  final ICRouter _router;

  InsanichessServer({
    required Logger logger,
    required ICRouter router,
  })  : _logger = logger,
        _router = router;

  Future<void> start() async {
    final InternetAddress address = InternetAddress.loopbackIPv4;
    final int port =
        int.parse(Platform.environment['INSANICHESS_PORT'] ?? '4040');

    final HttpServer server = await HttpServer.bind(address, port);
    _logger.info('InsanichessServer.create', 'Server listening on port $port');

    await _handleRequests(onServer: server);
  }

  Future<void> _handleRequests({required HttpServer onServer}) async {
    await for (final HttpRequest request in onServer) {
      await _router.handle(request);
    }
  }
}
