import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../util/either.dart';
import '../util/failures/backend_failure.dart';
import 'http_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance!;

  AuthService._({required HttpService httpService}) : _http = httpService;

  factory AuthService({required HttpService httpService}) {
    if (_instance != null) {
      throw StateError('AuthService already created');
    }

    _instance = AuthService._(httpService: httpService);
    return _instance!;
  }

  final HttpService _http;

  Future<Either<BackendFailure, InsanichessUser>> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final http.Response? response = await _http.post(
      [
        ICServerRoute.api,
        ICServerRoute.apiAuth,
        ICServerRoute.apiAuthLogin,
      ],
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(<String, String>{
        InsanichessUserJsonKey.email: email,
        InsanichessUserJsonKey.password: password,
      }),
    );
    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(InsanichessUser.fromJson(jsonDecode(response.body)));
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      case HttpStatus.notFound:
        return error(const NotFoundBackendFailure());
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      default:
        return error(const UnknownBackendFailure());
    }
  }

  Future<Either<BackendFailure, List>> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final http.Response? response = await _http.post(
      [
        ICServerRoute.api,
        ICServerRoute.apiAuth,
        ICServerRoute.apiAuthRegister,
      ],
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(<String, String>{
        InsanichessUserJsonKey.email: email,
        InsanichessUserJsonKey.password: password,
      }),
    );
    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.created:
        final Map<String, dynamic> body = jsonDecode(response.body);
        return value([
          InsanichessUser.fromJson(body['user']),
          InsanichessSettings.fromJson(body['settings']),
        ]);
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      case HttpStatus.forbidden:
        return error(const ForbiddenBackendFailure());
      case HttpStatus.notFound:
        return error(const NotFoundBackendFailure());
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      default:
        return error(const UnknownBackendFailure());
    }
  }
}
