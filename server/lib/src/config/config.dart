import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Holds configuration data.
abstract class Config {
  /// Is server running in debug mode?
  static const bool isDebug = true;

  /// Secret key for JWT signing and verification.
  static final jwtSecretKet =
      SecretKey(Platform.environment['INSANICHESS_JWT_SECRET_KEY']!);
}
