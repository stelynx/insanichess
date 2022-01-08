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

  /// Handler for login / registration POST [request].
  ///
  /// In case the request is not POST or the request body is not correct, the
  /// response has status code 400. In case a database error occurs, response
  /// code is 500. In case of successful login, status code is set to 200, and
  /// in case of successful registration, the status code is 201.
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
    if (email == null) return respondWithBadRequest(request);

    final String? appleId = body[InsanichessUserJsonKey.appleId];
    if (appleId != null) {
      return await _handleLoginWithApple(
        request,
        appleId: appleId,
        email: email,
      );
    }

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

  /// Auxiliary function that handles login /registration [request] with Apple.
  /// Instead of querying by email, it queries by [appleId]. If the previous and
  /// new email do not match, the existing one is replaced with [email].
  Future<void> _handleLoginWithApple(
    HttpRequest request, {
    required String appleId,
    required String email,
  }) async {
    final Either<DatabaseFailure, InsanichessUser?> userOrFailure =
        await _databaseService.getUserWithAppleId(appleId);

    if (userOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }

    if (userOrFailure.hasValue()) {
      InsanichessUser user = userOrFailure.value!;
      // Update email if changed.
      if (userOrFailure.value!.email != email) {
        user = InsanichessUser(
          id: userOrFailure.value!.id,
          email: email,
          appleId: userOrFailure.value!.appleId,
        );
        await _databaseService.updateUser(user);
      }
      return respondWithJson(request, user.toJson());
    }

    final Either<DatabaseFailure, InsanichessUser> newUserOrFailure =
        await _databaseService.createUser(email: email, appleId: appleId);
    return newUserOrFailure.isError()
        ? respondWithInternalServerError(request)
        : respondWithJson(
            request,
            newUserOrFailure.value.toJson(),
            statusCode: HttpStatus.created,
          );
  }
}