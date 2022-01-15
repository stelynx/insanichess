import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:uuid/uuid.dart';

import '../../../../insanichess_server.dart';
// ignore: unnecessary_import
import '../../../services/database/database_service.dart';
import '../../../util/either.dart';
import '../../../util/failures/database_failure.dart';
import '../../../util/functions/body_parser.dart';
import '../../../util/functions/default_responses.dart';
import '../../../util/functions/jwt.dart';

/// Controller that handles game requests.
class GameController {
  /// Database service instance.
  // ignore: unused_field
  final DatabaseService _databaseService;

  /// Constructs new `GameController` object with [databaseService].
  const GameController({required DatabaseService databaseService})
      : _databaseService = databaseService;

  Future<void> handleCreateGame(HttpRequest request) async {
    if (request.contentLength <= 0 ||
        request.headers.contentType?.value != ContentType.json.value) {
      print('here');
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
