import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../util/either.dart';
import '../util/failures/backend_failure.dart';
import '../util/functions/auth_header_value.dart';
import 'http_service.dart';

class BackendService {
  static BackendService? _instance;
  static BackendService get instance => _instance!;

  const BackendService._({required HttpService httpService})
      : _http = httpService;

  factory BackendService({required HttpService httpService}) {
    if (_instance != null) {
      throw StateError('BackendService already created');
    }

    _instance = BackendService._(httpService: httpService);
    return _instance!;
  }

  final HttpService _http;

  Future<void> notifyPlayerOnline(
    InsanichessPlayer player, {
    required bool isOnline,
  }) async {
    await _http.post(
      [
        ICServerRoute.api,
        ICServerRoute.apiPlayers,
        ICServerRoute.apiPlayersOnline,
      ],
      body: jsonEncode(<String, dynamic>{
        'online': isOnline,
      }),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );
  }

  Future<Either<BackendFailure, int>> getNumberOfPlayersOnline() async {
    final http.Response? response = await _http.get([
      ICServerRoute.api,
      ICServerRoute.apiPlayers,
      ICServerRoute.apiPlayersOnline,
      ICServerRoute.apiPlayersOnlineCount,
    ]);
    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(int.parse(response.body));
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, int>> getNumberOfGamesInProgress() async {
    final http.Response? response = await _http.get([
      ICServerRoute.api,
      ICServerRoute.apiGames,
      ICServerRoute.apiGamesLive,
      ICServerRoute.apiGamesLiveCount,
    ]);
    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(int.parse(response.body));
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, InsanichessPlayer?>> getPlayerMyself() async {
    final http.Response? response = await _http.get(
      [ICServerRoute.api, ICServerRoute.apiPlayer],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );
    if (response == null) return error(const UnknownBackendFailure());

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
    final http.Response? response = await _http.post(
      [ICServerRoute.api, ICServerRoute.apiPlayer],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(<String, dynamic>{
        InsanichessPlayerJsonKey.username: username,
      }),
    );
    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.created:
        return value(InsanichessPlayer.fromJson(jsonDecode(response.body)));
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, InsanichessSettings>> getSettings() async {
    final http.Response? response = await _http.get(
      [ICServerRoute.api, ICServerRoute.apiSettings],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );
    if (response == null) return error(const UnknownBackendFailure());

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
    final http.Response? response = await _http.patch(
      [ICServerRoute.api, ICServerRoute.apiSettings],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(settingObject),
    );
    if (response == null) return error(const UnknownBackendFailure());

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
    final http.Response? response = await _http.post(
      [ICServerRoute.api, ICServerRoute.apiChallenge],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(challenge.toJson()),
    );
    if (response == null) return error(const UnknownBackendFailure());

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
    final http.Response? response = await _http.get(
      [ICServerRoute.api, ICServerRoute.apiChallenge, challengeId],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );
    if (response == null) return error(const UnknownBackendFailure());

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
    final http.Response? response = await _http.delete(
      [ICServerRoute.api, ICServerRoute.apiChallenge, challengeId],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );
    if (response == null) return error(const UnknownBackendFailure());

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
    final http.Response? response = await _http.get(
      [
        ICServerRoute.api,
        ICServerRoute.apiGame,
        ICServerRoute.apiGameLive,
        liveGameId,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );
    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(InsanichessLiveGame.fromJson(jsonDecode(response.body)));
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, void>> acceptChallenge(
    String challengeId,
  ) async {
    final http.Response? response = await _http.get(
      [
        ICServerRoute.api,
        ICServerRoute.apiChallenge,
        challengeId,
        ICServerRoute.apiChallengeAccept,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );
    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(null);
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }
}
