import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:pausable_timer/pausable_timer.dart';
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
      return respondWithBadRequest(request);
    }

    final Either<DatabaseFailure, InsanichessPlayer?> playerOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerOrFailure.isError() || !playerOrFailure.hasValue()) {
      return respondWithBadRequest(request);
    }

    challenge = challenge.addCreatedBy(playerOrFailure.value!);

    return challenge.isPrivate
        ? await _handleCreatePrivateGame(request, challenge)
        : await _handleCreatePublicGame(request, challenge);
  }

  /// Handler for GET challenge.
  ///
  /// Returns data about challenge with [challengeId].
  ///
  /// Response is 500 in case of internal server error, 401 if no JWT token is
  /// provided, 400 in case [challengeId] is empty, 404 if challenge with
  /// [challengeId] not found in [memory.openPrivateChallenges], and 200 if challenge
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

    if (!memory.openPrivateChallenges.containsKey(challengeId)) {
      return respondWithNotFound(request);
    }

    return respondWithJson(
      request,
      memory.openPrivateChallenges[challengeId]!.toJson(),
    );
  }

  /// Handler for DELETE challenge.
  ///
  /// Deletes the challenge with [challengeId] from [memory].
  ///
  /// Response is 500 in case of internal server error, 401 if no JWT token is
  /// provided, 400 if [challengeId] is empty, 404 if [challengeId] not found in
  /// [memory.openPrivateChallenges], 403 if user from JWT token did not create the
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

    if (!memory.openPrivateChallenges.containsKey(challengeId)) {
      return respondWithNotFound(request);
    }

    final Either<DatabaseFailure, InsanichessPlayer?> playerOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }
    if (!playerOrFailure.hasValue()) return respondWithBadRequest(request);

    if (memory.openPrivateChallenges[challengeId]!.createdBy !=
        playerOrFailure.value!) {
      return respondWithForbidden(request);
    }

    memory.openPrivateChallenges.remove(challengeId);
    return respondWithOk(request);
  }

  /// Handler for accepting challenge with [challengeId].
  ///
  /// Returns 500 in case of internal error, 400 if no id is provided, 401 in
  /// case JWT is not valid, 404 if challenge with [challengeId] is not found in
  /// [memory.openPrivateChallenges], 403 if user that created the challenge is the
  /// same as accepting it or challenge is not in status `created`, otherwise
  /// 200.
  ///
  /// Accepts the challenge, creates a game with id of the challenge and returns
  /// empty body. It also creates the broadcast stream of events and starts the
  /// timer in which white player must make his first move.
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

    if (!memory.openPrivateChallenges.containsKey(challengeId)) {
      return respondWithNotFound(request);
    }

    final Either<DatabaseFailure, InsanichessPlayer?> playerOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }
    if (!playerOrFailure.hasValue()) return respondWithBadRequest(request);

    if (playerOrFailure.value! ==
        memory.openPrivateChallenges[challengeId]!.createdBy) {
      return respondWithForbidden(request);
    }

    final InsanichessChallenge? challenge =
        memory.openPrivateChallenges[challengeId];
    if (challenge == null) return respondWithInternalServerError(request);

    if (challenge.status != ChallengeStatus.created) {
      return respondWithForbidden(request);
    }

    return await _respondWithGameStart(
      request,
      challenge: challenge,
      challengeId: challengeId,
      isPublic: false,
      acceptor: playerOrFailure.value!,
    );
  }

  /// Handler for declining challenge with [challengeId].
  ///
  /// Returns 500 in case of internal error, 400 if no id is provided, 401 in
  /// case JWT is not valid, 404 if challenge with [challengeId] is not found in
  /// [memory.openPrivateChallenges], 403 if user that created the challenge is the
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

    if (!memory.openPrivateChallenges.containsKey(challengeId)) {
      return respondWithNotFound(request);
    }

    final Either<DatabaseFailure, InsanichessPlayer?> playerOrFailure =
        await _databaseService.getPlayerWithUserId(userIdIfValid);
    if (playerOrFailure.isError()) {
      return respondWithInternalServerError(request);
    }
    if (!playerOrFailure.hasValue()) return respondWithBadRequest(request);

    if (playerOrFailure.value! ==
        memory.openPrivateChallenges[challengeId]!.createdBy) {
      return respondWithForbidden(request);
    }

    final InsanichessChallenge? challenge =
        memory.openPrivateChallenges[challengeId];
    if (challenge == null) return respondWithInternalServerError(request);

    if (challenge.status != ChallengeStatus.created) {
      return respondWithForbidden(request);
    }

    memory.openPrivateChallenges[challengeId] =
        challenge.updateStatus(ChallengeStatus.declined);
    return respondWithOk(request);
  }

  // Helpers

  /// Notifies stream listeners that the game has been disbanded and performs
  /// cleanup after finished game.
  Future<void> _disbandGame(String gameId) async {
    // This should never happen but let's keep it here just in case.
    if (memory.gamesInProgress[gameId]!.status !=
        insanichess.GameStatus.notStarted) return;

    memory.gameWhiteStreamControllers[gameId]!.add(const DisbandedGameEvent());
    memory.gameBlackStreamControllers[gameId]!.add(const DisbandedGameEvent());
    memory.gameBroadcastStreamControllers[gameId]!
        .add(const DisbandedGameEvent());

    await memory.cleanUpAfterGame(gameId);
  }

  /// Helper for private game creation
  Future<void> _handleCreatePrivateGame(
    HttpRequest request,
    InsanichessChallenge challenge,
  ) async {
    String id = _getUuid();

    memory.openPrivateChallenges[id] =
        challenge.updateStatus(ChallengeStatus.created);
    Future.delayed(
      InsanichessConfig.expirePrivateChallengeAfter,
      () {
        memory.openPrivateChallenges.remove(id);
        print(memory.openPrivateChallenges);
      },
    );
    print(memory.openPrivateChallenges);

    return respondWithJson(
      request,
      <String, dynamic>{
        'id': id,
      },
      statusCode: HttpStatus.created,
    );
  }

  /// Helper for creating a public challenge or automatically accepting one if
  /// there exists a challenge with the same time control.
  ///
  /// Check if there is a challenge that has not been accepted yet with given
  /// requested time control. The prefered colors should also match, and the
  /// user should not be able to join his own challenge. If so, accept the
  /// challenge in FIFO manner, otherwise create a new entry in
  /// `memory.openPublicChallenges`.
  Future<void> _handleCreatePublicGame(
    HttpRequest request,
    InsanichessChallenge challenge,
  ) async {
    // Check for existing.
    String? existingChallengeId;

    try {
      existingChallengeId = memory.openPublicChallenges.entries
          .firstWhere((MapEntry<String, InsanichessChallenge> entry) =>
              entry.value.status == ChallengeStatus.created &&
              entry.value.createdBy != challenge.createdBy &&
              entry.value.timeControl == challenge.timeControl &&
              (entry.value.preferColor == null ||
                  challenge.preferColor == null ||
                  (entry.value.preferColor == insanichess.PieceColor.white &&
                      challenge.preferColor == insanichess.PieceColor.black) ||
                  (entry.value.preferColor == insanichess.PieceColor.black &&
                      challenge.preferColor == insanichess.PieceColor.white)))
          .key;
    } on StateError catch (_) {}

    if (existingChallengeId != null) {
      return await _respondWithGameStart(
        request,
        challenge: memory.openPublicChallenges[existingChallengeId]!,
        challengeId: existingChallengeId,
        isPublic: true,
        acceptor: challenge.createdBy!,
      );
    }

    // Create new challenge.
    String id = _getUuid();

    memory.openPublicChallenges[id] =
        challenge.updateStatus(ChallengeStatus.created);
    Future.delayed(
      InsanichessConfig.expirePublicChallengeAfter,
      () {
        memory.openPublicChallenges.remove(id);
        print(memory.openPublicChallenges);
      },
    );
    print(memory.openPublicChallenges);

    return respondWithJson(
      request,
      <String, dynamic>{
        'id': id,
      },
      statusCode: HttpStatus.created,
    );
  }

  /// When a private challenge is accepted or a public challenge has its match
  /// in already available public challenges, call this method to create a game
  /// and required memory objects.
  Future<void> _respondWithGameStart(
    HttpRequest request, {
    required InsanichessChallenge challenge,
    required String challengeId,
    required bool isPublic,
    required InsanichessPlayer acceptor,
  }) async {
    // Choose colors.
    final insanichess.PieceColor challengeCreatorColor =
        challenge.preferColor ??
            (Random().nextInt(2) == 0
                ? insanichess.PieceColor.white
                : insanichess.PieceColor.black);
    final InsanichessPlayer playerWhite;
    final InsanichessPlayer playerBlack;
    if (challengeCreatorColor == insanichess.PieceColor.white) {
      playerWhite = challenge.createdBy!;
      playerBlack = acceptor;
    } else {
      playerWhite = acceptor;
      playerBlack = challenge.createdBy!;
    }

    // Determine if undo's are allowed for this game.
    final Either<DatabaseFailure, bool> whiteAllowsUndo =
        await _databaseService.playerAllowsUndoInLiveGame(playerWhite.id);
    final Either<DatabaseFailure, bool> blackAllowsUndo =
        await _databaseService.playerAllowsUndoInLiveGame(playerBlack.id);
    final bool undoAllowed = !whiteAllowsUndo.isError() &&
        !blackAllowsUndo.isError() &&
        whiteAllowsUndo.value &&
        blackAllowsUndo.value;

    final InsanichessLiveGame game = InsanichessLiveGame(
      id: challengeId,
      whitePlayer: playerWhite,
      blackPlayer: playerBlack,
      timeControl: challenge.timeControl,
      undoAllowed: undoAllowed,
    );

    if (isPublic) {
      memory.openPublicChallenges[challengeId] = memory
          .openPublicChallenges[challengeId]!
          .updateStatus(ChallengeStatus.accepted);
    } else {
      memory.openPrivateChallenges[challengeId] =
          challenge.updateStatus(ChallengeStatus.accepted);
    }
    memory.gamesInProgress[challengeId] = game;

    memory.gameBroadcastStreamControllers[challengeId] =
        StreamController<InsanichessGameEvent>.broadcast();
    memory.gameBroadcastConnectedSockets[challengeId] = <WebSocket>[];

    // This streams should not be broadcast because they will be forwarded to
    // only one socket.
    memory.gameWhiteStreamControllers[challengeId] =
        StreamController<InsanichessGameEvent>();
    memory.gameBlackStreamControllers[challengeId] =
        StreamController<InsanichessGameEvent>();

    if (isPublic) {
      respondWithJson(
        request,
        <String, dynamic>{
          'id': challengeId,
        },
      );
    } else {
      respondWithOk(request);
    }

    memory.gameTimerPlayerFlagged[challengeId] = PausableTimer(
      InsanichessConfig.whiteForFirstMove,
      () => _disbandGame(challengeId),
    );
    memory.gameTimerPlayerFlagged[challengeId]!.start();
  }

  /// Generates new uuid to be used as temporary challenge / game id.
  ///
  /// Returns the uuid that is not the same to any existing id in the
  /// `memory.openPrivateChallenges`, `memory.openPublicChallenges`, and
  /// `memory.gamesInProgress`.
  String _getUuid() {
    final Uuid uuid = Uuid();

    String id = uuid.v4();
    while (memory.openPublicChallenges.containsKey(id) ||
        memory.openPrivateChallenges.containsKey(id) ||
        memory.gamesInProgress.containsKey(id)) {
      id = uuid.v4();
    }
    return id;
  }
}
