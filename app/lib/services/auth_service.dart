import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../util/either.dart';
import '../util/failures/backend_failure.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance!;

  const AuthService._();

  factory AuthService() {
    if (_instance != null) {
      throw StateError('AuthService already created');
    }

    _instance = const AuthService._();
    return _instance!;
  }

  Future<Either<BackendFailure, InsanichessUser>> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final http.Response response = await http.post(
      _uriForPath([
        ICServerRoute.api,
        ICServerRoute.apiAuth,
        ICServerRoute.apiAuthLogin,
      ]),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(<String, String>{
        InsanichessUserJsonKey.email: email,
        InsanichessUserJsonKey.password: password,
      }),
    );

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

  Future<Either<BackendFailure, InsanichessUser>> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final http.Response response = await http.post(
      _uriForPath([
        ICServerRoute.api,
        ICServerRoute.apiAuth,
        ICServerRoute.apiAuthRegister,
      ]),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(<String, String>{
        InsanichessUserJsonKey.email: email,
        InsanichessUserJsonKey.password: password,
      }),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(InsanichessUser.fromJson(jsonDecode(response.body)));
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

  Uri _uriForPath(List<String> path) {
    return Uri.parse('http://localhost:4040/${path.join('/')}');
  }
}
