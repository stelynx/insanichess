import 'dart:convert';
import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../services/database/database_service.dart';
import '../../../util/either.dart';
import '../../../util/failures/database_failure.dart';
import '../../../util/functions/default_responses.dart';

class AuthController {
  final DatabaseService _databaseService;

  const AuthController({required DatabaseService databaseService})
      : _databaseService = databaseService;

  Future<void> handleLogin(HttpRequest request) async {
    if (request.method != 'POST' ||
        request.contentLength <= 0 ||
        request.headers.contentType?.value != ContentType.json.value) {
      return respondWithBadRequest(request);
    }

    final String content = await utf8.decodeStream(request);
    final Map<String, dynamic> body = jsonDecode(content);

    final String? email = body[InsanichessUserJsonKey.email];
    if (email == null) return respondWithBadRequest(request);

    final Either<DatabaseFailure, InsanichessUser?> userOrFailure =
        await _databaseService.getUserWithEmail(email);

    if (userOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }

    if (userOrFailure.hasValue()) {
      return respondWithJson(request, userOrFailure.value!.toJson());
    }

    final Either<DatabaseFailure, InsanichessUser> newUserOrFailure =
        await _databaseService.createUser(email: email);
    return newUserOrFailure.isError()
        ? respondWithInternalServerError(request)
        : respondWithJson(
            request,
            newUserOrFailure.value.toJson(),
            statusCode: HttpStatus.created,
          );
  }
}
