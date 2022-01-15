import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:uuid/uuid.dart';

import '../../../memory/memory.dart';
import '../../../services/database/database_service.dart';
import '../../../util/either.dart';
import '../../../util/failures/database_failure.dart';
import '../../../util/functions/body_parser.dart';
import '../../../util/functions/default_responses.dart';
import '../../../util/functions/jwt.dart';

/// Controller that handles challenge requests.
class ChallengeController {
  /// Database service instance.
  final DatabaseService _databaseService;

  /// Constructs new `ChallengeController` object with [databaseService].
  const ChallengeController({required DatabaseService databaseService})
      : _databaseService = databaseService;

  /// Handler for POST challenge [request].
  ///
  /// Creates a challenge in [memory] that lasts for one minute. After that, the
  /// challenge is automatically deleted.
  ///
  /// The response is 500 in case of internal server error, 400 in case of bad
  /// request, 401 in case no JWT token provided, otherwise 201 with challenge
  /// id in body.
  ///
  /// Response contains challenge id.
  Future<void> handleCreateChallenge(HttpRequest request) async {
    if (request.contentLength <= 0 ||
        request.headers.contentType?.value != ContentType.json.value) {
      return respondWithBadRequest(request);
    }

    final Map<String, dynamic> body = await parseBodyFromRequest(request);

    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    InsanichessChallenge challenge;
    try {
      challenge = InsanichessChallenge.fromJson(body);
    } catch (_) {
      return respondWithBadRequest(request);
    }

    final Either<DatabaseFailure, InsanichessPlayer?> playerOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerOrFailure.isError() || !playerOrFailure.hasValue()) {
      return respondWithBadRequest(request);
    }

    challenge = challenge.addCreatedBy(playerOrFailure.value!.username);

    if (challenge.isPrivate) {
      return await _handleCreatePrivateGame(request, challenge);
    }

    throw UnimplementedError();
  }

  /// Handler for GET challenge.
  ///
  /// Returns data about challenge with [challengeId].
  ///
  /// Response is 500 in case of internal server error, 401 if no JWT token is
  /// provided, 400 in case [challengeId] is empty, 404 if challenge with
  /// [challengeId] not found in [memory.openChallenges], and 200 if challenge
  /// is found with challenge details in body.
  ///
  /// Returns challenge details.
  Future<void> handleGetChallengeDetails(
    HttpRequest request, {
    required String challengeId,
  }) async {
    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    if (challengeId.isEmpty) return respondWithBadRequest(request);

    if (!memory.openChallenges.containsKey(challengeId)) {
      return respondWithNotFound(request);
    }

    return respondWithJson(
      request,
      memory.openChallenges[challengeId]!.toJson(),
    );
  }

  /// Handler for DELETE challenge.
  ///
  /// Deletes the challenge with [challengeId] from [memory].
  ///
  /// Response is 500 in case of internal server error, 401 if no JWT token is
  /// provided, 400 if [challengeId] is empty, 404 if [challengeId] not found in
  /// [memory.openChallenges], 403 if user from JWT token did not create the
  /// challenge, and 200 in case a delete was successful.
  Future<void> handleCancelChallenge(
    HttpRequest request, {
    required String challengeId,
  }) async {
    // Check JWT.
    final String? jwtToken = getJwtFromRequest(request);
    if (jwtToken == null) return respondWithUnauthorized(request);
    final String? userIdIfValid = getUserIdFromJwtToken(jwtToken);
    if (userIdIfValid == null) return respondWithUnauthorized(request);

    if (challengeId.isEmpty) return respondWithBadRequest(request);

    if (!memory.openChallenges.containsKey(challengeId)) {
      return respondWithNotFound(request);
    }

    final Either<DatabaseFailure, InsanichessPlayer?> playerOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }
    if (!playerOrFailure.hasValue()) return respondWithBadRequest(request);

    if (memory.openChallenges[challengeId]!.createdBy !=
        playerOrFailure.value!.username) {
      return respondWithForbidden(request);
    }

    memory.openChallenges.remove(challengeId);
    return respondWithOk(request);
  }

  // Helpers

  /// Helper for private game creation
  Future<void> _handleCreatePrivateGame(
    HttpRequest request,
    InsanichessChallenge challenge,
  ) async {
    final Uuid uuid = Uuid();

    String id = uuid.v4();
    while (memory.openChallenges.keys.contains(id)) {
      id = uuid.v4();
    }

    memory.openChallenges[id] = challenge;
    Future.delayed(
      const Duration(minutes: 1),
      () {
        memory.openChallenges.remove(id);
        print(memory.openChallenges);
      },
    );
    print(memory.openChallenges);

    return respondWithJson(
      request,
      <String, dynamic>{
        'id': id,
      },
      statusCode: HttpStatus.created,
    );
  }
}
