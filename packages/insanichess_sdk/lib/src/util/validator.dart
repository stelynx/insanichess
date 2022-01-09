/// Provides validation functions.
abstract class InsanichessValidator {
  /// Validates [email].
  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  /// Validates [password].
  static bool isValidPassword(String password) {
    return password.contains(' ') ? false : password.length >= 8;
  }
}
