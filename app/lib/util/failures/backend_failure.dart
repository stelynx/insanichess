import 'dart:io';

import 'failure.dart';

abstract class BackendFailure extends Failure {
  const BackendFailure();

  /// Returns appropriate [BackendFailure] for given [statusCode]. The order in
  /// switch statement is based on subjective opinion on likelihood of the
  /// appearance of these status codes.
  factory BackendFailure.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case HttpStatus.notFound:
        return const NotFoundBackendFailure();
      case HttpStatus.badGateway:
        return const BadGatewayBackendFailure();
      case HttpStatus.internalServerError:
        return const InternalServerErrorBackendFailure();
      case HttpStatus.forbidden:
        return const ForbiddenBackendFailure();
      case HttpStatus.badRequest:
        return const BadRequestBackendFailure();
      case HttpStatus.unauthorized:
        return const UnauthorizedBackendFailure();
      default:
        return const UnknownBackendFailure();
    }
  }
}

class BadRequestBackendFailure extends BackendFailure {
  const BadRequestBackendFailure();
}

class UnauthorizedBackendFailure extends BackendFailure {
  const UnauthorizedBackendFailure();
}

class ForbiddenBackendFailure extends BackendFailure {
  const ForbiddenBackendFailure();
}

class NotFoundBackendFailure extends BackendFailure {
  const NotFoundBackendFailure();
}

class InternalServerErrorBackendFailure extends BackendFailure {
  const InternalServerErrorBackendFailure();
}

class BadGatewayBackendFailure extends BackendFailure {
  const BadGatewayBackendFailure();
}

class UnknownBackendFailure extends BackendFailure {
  const UnknownBackendFailure();
}
