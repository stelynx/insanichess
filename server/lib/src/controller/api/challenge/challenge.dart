import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:insanichess/insanichess.dart' as insanichess;
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

    if (challenge.status != ChallengeStatus.initiated) {
      print('here');
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

  /// Handler for accepting challenge with [challengeId].
  ///
  /// Returns 500 in case of internal error, 400 if no id is provided, 401 in
  /// case JWT is not valid, 404 if challenge with [challengeId] is not found in
  /// [memory.openChallenges], 403 if user that created the challenge is the
  /// same as accepting it or challenge is not in status `created`, otherwise
  /// 200.
  ///
  /// Accepts the challenge, creates a game with id of the challenge and returns
  /// empty body. It also creates the broadcast stream of events.
  Future<void> handleAcceptChallenge(
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

    if (playerOrFailure.value!.username ==
        memory.openChallenges[challengeId]!.createdBy) {
      return respondWithForbidden(request);
    }

    final InsanichessChallenge? challenge = memory.openChallenges[challengeId];
    if (challenge == null) return respondWithInternalServerError(request);

    if (challenge.status != ChallengeStatus.created) {
      return respondWithForbidden(request);
    }

    final Either<DatabaseFailure, InsanichessPlayer?>
        challengeCreatorOrFailure =
        await _databaseService.getPlayerWithUsername(challenge.createdBy!);
    if (challengeCreatorOrFailure.isError() ||
        !challengeCreatorOrFailure.hasValue()) {
      return respondWithInternalServerError(request);
    }

    // Choose colors.
    final insanichess.PieceColor challengeCreatorColor =
        challenge.preferColor ??
            (Random().nextInt(2) == 0
                ? insanichess.PieceColor.white
                : insanichess.PieceColor.black);
    final InsanichessPlayer playerWhite;
    final InsanichessPlayer playerBlack;
    if (challengeCreatorColor == insanichess.PieceColor.white) {
      playerWhite = challengeCreatorOrFailure.value!;
      playerBlack = playerOrFailure.value!;
    } else {
      playerWhite = playerOrFailure.value!;
      playerBlack = challengeCreatorOrFailure.value!;
    }

    final InsanichessGame game = InsanichessGame(
      id: challengeId,
      whitePlayer: playerWhite,
      blackPlayer: playerBlack,
      timeControl: challenge.timeControl,
    );

    memory.openChallenges[challengeId] =
        challenge.updateStatus(ChallengeStatus.accepted);
    memory.gamesInProgress[challengeId] = game;

    memory.gameBroadcastStreamControllers[challengeId] =
        StreamController<InsanichessGameEvent>.broadcast();
    memory.gameBroadcastConnectedSockets[challengeId] = <WebSocket>[];

    return respondWithOk(request);
  }

  /// Handler for declining challenge with [challengeId].
  ///
  /// Returns 500 in case of internal error, 400 if no id is provided, 401 in
  /// case JWT is not valid, 404 if challenge with [challengeId] is not found in
  /// [memory.openChallenges], 403 if user that created the challenge is the
  /// same as declining it or the challenge is not in status `created`,
  /// otherwise 200.
  ///
  /// Deletes the challenge and returns nothing.
  Future<void> handleDeclineChallenge(
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

    if (playerOrFailure.value!.username ==
        memory.openChallenges[challengeId]!.createdBy) {
      return respondWithForbidden(request);
    }

    final InsanichessChallenge? challenge = memory.openChallenges[challengeId];
    if (challenge == null) return respondWithInternalServerError(request);

    if (challenge.status != ChallengeStatus.created) {
      return respondWithForbidden(request);
    }

    memory.openChallenges[challengeId] =
        challenge.updateStatus(ChallengeStatus.declined);
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
    while (memory.openChallenges.containsKey(id) ||
        memory.gamesInProgress.containsKey(id)) {
      id = uuid.v4();
    }

    memory.openChallenges[id] = challenge.updateStatus(ChallengeStatus.created);
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
