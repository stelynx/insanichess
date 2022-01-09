import 'dart:convert';
import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../../services/database/database_service.dart';
import '../../../util/either.dart';
import '../../../util/failures/database_failure.dart';
import '../../../util/functions/default_responses.dart';

/// Controller that handles auth requests.
class AuthController {
  /// Database service instance.
  final DatabaseService _databaseService;

  /// Constructs new `AuthController` object with [databaseService].
  const AuthController({required DatabaseService databaseService})
      : _databaseService = databaseService;

  /// Handler for login POST [request].
  ///
  /// In case the request is not POST or the request body is not correct, the
  /// response has status code 400. In case a database error occurs, response
  /// code is 500. In case of successful login, status code is set to 200, and
  /// in case of user not found, the status code is 404.
  ///
  /// The response contains data about the user.
  Future<void> handleLogin(HttpRequest request) async {
    if (request.method != 'POST' ||
        request.contentLength <= 0 ||
        request.headers.contentType?.value != ContentType.json.value) {
      return respondWithBadRequest(request);
    }

    final String content = await utf8.decodeStream(request);
    final Map<String, dynamic> body = jsonDecode(content);

    final String? email = body[InsanichessUserJsonKey.email];
    final String? plainPassword = body['password'];
    if (email == null || plainPassword == null) {
      return respondWithBadRequest(request);
    }

    final Either<DatabaseFailure, bool> userExistsOrFailure =
        await _databaseService.existsUserWithEmailAndPassword(
            email, plainPassword);

    if (userExistsOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }
    if (userExistsOrFailure.value == false) return respondWithNotFound(request);

    final Either<DatabaseFailure, InsanichessUser?> userOrFailure =
        await _databaseService.getUserWithEmail(email);
    return userOrFailure.isError() || !userOrFailure.hasValue()
        ? respondWithInternalServerError(request)
        : respondWithJson(request, userOrFailure.value!.toJson());
  }

  Future<void> handleRegistration(HttpRequest request) async {
    if (request.method != 'POST' ||
        request.contentLength <= 0 ||
        request.headers.contentType?.value != ContentType.json.value) {
      return respondWithBadRequest(request);
    }

    final String content = await utf8.decodeStream(request);
    final Map<String, dynamic> body = jsonDecode(content);

    final String? email = body[InsanichessUserJsonKey.email];
    final String? plainPassword = body['password'];
    if (email == null || plainPassword == null) {
      return respondWithBadRequest(request);
    }

    final Either<DatabaseFailure, bool> userExistsOrFailure =
        await _databaseService.existsUserWithEmailAndPassword(email);

    if (userExistsOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }
    if (userExistsOrFailure.value == true) {
      return respondWithBadRequest(request);
    }

    final Either<DatabaseFailure, InsanichessUser> userOrFailure =
        await _databaseService.createUser(
            email: email, password: plainPassword);

    if (userOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }

    return respondWithJson(request, userOrFailure.value.toJson());
  }
}
