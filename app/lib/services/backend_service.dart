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
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
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
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
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
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
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
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, String>> createChallenge(
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

    switch (response.statusCode) {
      case HttpStatus.created:
        return value(jsonDecode(response.body)['id']);
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, InsanichessChallenge>> getChallenge(
    String challengeId,
  ) async {
    final http.Response response = await http.get(
      uriForPath([ICServerRoute.api, ICServerRoute.apiChallenge, challengeId]),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(InsanichessChallenge.fromJson(jsonDecode(response.body)));
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, void>> cancelChallenge(
    String challengeId,
  ) async {
    final http.Response response = await http.delete(
      uriForPath([ICServerRoute.api, ICServerRoute.apiChallenge, challengeId]),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(null);
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, InsanichessLiveGame>> getLiveGameDetails(
    String liveGameId,
  ) async {
    final http.Response response = await http.get(
      uriForPath([
        ICServerRoute.api,
        ICServerRoute.apiGame,
        ICServerRoute.apiGameLive,
        liveGameId,
      ]),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(InsanichessLiveGame.fromJson(jsonDecode(response.body)));
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }
}
