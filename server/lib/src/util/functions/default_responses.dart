import 'dart:convert';
import 'dart:io';

void respondWithOk(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..close();
}

void respondWithBadRequest(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.badRequest
    ..close();
}

void respondWithInternalServerError(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.internalServerError
    ..close();
}

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