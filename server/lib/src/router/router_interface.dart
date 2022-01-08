import 'dart:io';

/// Interface that every router should implement.
abstract class RouterInterface {
  /// Provides `const` constructor to all implementers.
  const RouterInterface();

  /// Responds to a [request] by sending data back using [request.response].
  Future<void> handle(HttpRequest request);
}
