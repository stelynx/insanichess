import 'dart:convert';
import 'dart:io';

/// Sends 200.
void respondWithOk(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..close();
}

/// Sends 400.
void respondWithBadRequest(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.badRequest
    ..close();
}

/// Sends 401.
void respondWithUnauthorized(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.unauthorized
    ..close();
}

/// Sends 403.
void respondWithForbidden(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.forbidden
    ..close();
}

/// Sends 404.
void respondWithNotFound(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.notFound
    ..close();
}

/// Sends 500.
void respondWithInternalServerError(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.internalServerError
    ..close();
}

/// Sends back [json] with [statusCode] (default 200).
void respondWithJson(
  HttpRequest request,
  Map<String, dynamic> json, {
  int statusCode = HttpStatus.ok,
}) {
  request.response
    ..headers.contentType = ContentType.json
    ..statusCode = statusCode
    ..write(jsonEncode(json))
    ..close();
}
