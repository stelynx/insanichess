import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../util/either.dart';
import '../util/failures/backend_failure.dart';
import '../util/functions/auth_header_value.dart';
import '../util/functions/uri_for_path.dart';

class BackendService {
  static BackendService? _instance;
  static BackendService get instance => _instance!;

  const BackendService._();

  factory BackendService() {
    if (_instance != null) {
      throw StateError('BackendService already created');
    }

    _instance = const BackendService._();
    return _instance!;
  }

  Future<Either<BackendFailure, InsanichessPlayer?>> getPlayerMyself() async {
    final http.Response response = await http.get(
      uriForPath([ICServerRoute.api, ICServerRoute.apiPlayer]),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(InsanichessPlayer.fromJson(jsonDecode(response.body)));
      case HttpStatus.notFound:
        return value(null);
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      default:
        return error(const UnknownBackendFailure());
    }
  }

  Future<Either<BackendFailure, InsanichessPlayer>> createPlayer({
    required String username,
  }) async {
    final http.Response response = await http.post(
      uriForPath([ICServerRoute.api, ICServerRoute.apiPlayer]),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(<String, dynamic>{
        InsanichessPlayerJsonKey.username: username,
      }),
    );

    switch (response.statusCode) {
      case HttpStatus.created:
        return value(InsanichessPlayer.fromJson(jsonDecode(response.body)));
      case HttpStatus.forbidden:
        return error(const ForbiddenBackendFailure());
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      default:
        return error(const UnknownBackendFailure());
    }
  }

  Future<Either<BackendFailure, InsanichessSettings>> getSettings() async {
    final http.Response response = await http.get(
      uriForPath([ICServerRoute.api, ICServerRoute.apiSettings]),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(InsanichessSettings.fromJson(jsonDecode(response.body)));
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      default:
        return error(const UnknownBackendFailure());
    }
  }

  /// Updates settings with [settingObject] which is either a key:value pair or
  /// otb:{key:value}.
  Future<Either<BackendFailure, void>> updateSetting(
    Map<String, dynamic> settingObject,
  ) async {
    final http.Response response = await http.patch(
      uriForPath([ICServerRoute.api, ICServerRoute.apiSettings]),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(settingObject),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(null);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      default:
        return error(const UnknownBackendFailure());
    }
  }

  Future<Either<BackendFailure, InsanichessChallenge>> createChallenge(
    InsanichessChallenge challenge,
  ) async {
    final http.Response response = await http.post(
      uriForPath([ICServerRoute.api, ICServerRoute.apiChallenge]),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(challenge.toJson()),
    );

    print(response.body);

    switch (response.statusCode) {
      case HttpStatus.created:
        return value(InsanichessChallenge.fromJson(jsonDecode(response.body)));
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      default:
        return error(const UnknownBackendFailure());
    }
  }
}
