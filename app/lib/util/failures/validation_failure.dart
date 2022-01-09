import 'failure.dart';

abstract class ValidationFailure extends Failure {
  const ValidationFailure();
}

class EmailValidationFailure extends ValidationFailure {
  const EmailValidationFailure();
}

class PasswordValidationFailure extends ValidationFailure {
  const PasswordValidationFailure();
}
