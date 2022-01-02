import 'dart:io';

import 'package:insanichess_server/src/util/logger.dart';

class InsanichessServer {
  final Logger _logger;

  const InsanichessServer({
    required Logger logger,
  }) : _logger = logger;

  Future<void> create() async {
    final InternetAddress address = InternetAddress.loopbackIPv4;
    final int port =
        int.parse(Platform.environment['INSANICHESS_PORT'] ?? '4040');
    await HttpServer.bind(address, port);
    _logger.info('InsanichessServer.create', 'Server listening on port $port');
  }
}
