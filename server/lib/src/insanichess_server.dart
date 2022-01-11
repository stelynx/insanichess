import 'dart:io';

import 'config/config.dart';
import 'router/ic_router.dart';
import 'util/functions/default_responses.dart';
import 'util/logger.dart';

/// The main class of the server package.
class InsanichessServer {
  /// Logger instance.
  final Logger _logger;

  /// Main router instance.
  final ICRouter _router;

  /// Constructs new `InsanichessServer` object.
  ///
  /// To actually start the server, call [start] method.
  InsanichessServer({
    required Logger logger,
    required ICRouter router,
  })  : _logger = logger,
        _router = router;

  /// Starts the server.
  Future<void> start() async {
    final InternetAddress address = InternetAddress.loopbackIPv4;
    final int port =
        int.parse(Platform.environment['INSANICHESS_PORT'] ?? '4040');

    final HttpServer server = await HttpServer.bind(address, port);
    _logger.info('InsanichessServer.create', 'Server listening on port $port');

    await _handleRequests(onServer: server);
  }

  /// Passes every request [onServer] to [_router].
  Future<void> _handleRequests({required HttpServer onServer}) async {
    await for (final HttpRequest request in onServer) {
      try {
        await _router.handle(request);
      } on Error catch (e) {
        _logger.error('InsanichessServer', e.stackTrace);
        respondWithInternalServerError(request);
        if (Config.isDebug) rethrow;
      }
    }
  }
}
