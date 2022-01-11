import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../config/config.dart';

/// Returns a new JWT token for [user].
String generateJwtForUser(InsanichessUser user) {
  final JWT jwt = JWT(<String, dynamic>{
    'id': user.id,
    'server': {
      'id': 'insanichess_server',
      'loc': 'eu',
    },
  });
  return jwt.sign(Config.jwtSecretKet);
}

/// Returns user id if [token] is valid, otherwise `null`.
String? getUserIdFromJwtToken(String token) {
  try {
    final JWT decodedJwtToken = JWT.verify(token, Config.jwtSecretKet);
    return decodedJwtToken.payload['id'];
  } catch (e) {
    return null;
  }
}
