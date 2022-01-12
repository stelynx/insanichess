import 'failure.dart';

abstract class BackendFailure extends Failure {
  const BackendFailure();
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

class UnknownBackendFailure extends BackendFailure {
  const UnknownBackendFailure();
}
