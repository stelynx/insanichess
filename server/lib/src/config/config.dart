import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Holds configuration data.
abstract class Config {
  /// Is server running in debug mode?
  static final bool isDebug =
      Platform.environment['INSANICHESS_IS_DEBUG'] == 'true';

  /// Secret key for JWT signing and verification.
  static final jwtSecretKet =
      SecretKey(Platform.environment['INSANICHESS_JWT_SECRET_KEY']!);

  /// In how many seconds white has to perform a move before the game is
  /// disbanded.
  static const int secondsWhiteForFirstMove = 30;

  /// The duration in which a private challenge needs to be accepted before it
  /// is cancelled by the server.
  static const Duration expirePrivateChallengeAfter = Duration(minutes: 2);

  /// The duration in which a public challenge needs to be matchmade before it
  /// is cancelled by the server.
  static const Duration expirePublicChallengeAfter = Duration(hours: 1);
}
