import 'dart:io';

import '../../../controller/api/challenge/challenge.dart';
import '../../../services/database/database_service.dart';
import '../../../util/functions/default_responses.dart';
import '../../router_interface.dart';

/// Router that handles requests on
/// `/ICServerRoute.api/ICServerRoute.apiChallenge`.
class ChallengeRouter implements RouterInterface {
  /// The corresponding controller.
  final ChallengeController _challengeController;

  /// Constructs new `ChallengeRouter` object with given [challengeController].
  ChallengeRouter({ChallengeController? challengeController})
      : _challengeController = challengeController ??
            ChallengeController(databaseService: DatabaseService.instance);

  /// Request handler / rerouter.
  @override
  Future<void> handle(HttpRequest request) async {
    final List<String> pathSegments = request.uri.pathSegments;

    if (pathSegments.length == 2) {
      if (request.method == 'POST') {
        return await _challengeController.handleCreateChallenge(request);
      }

      return respondWithBadRequest(request);
    }

    // /api/challenge/<id>
    if (pathSegments.length == 3) {
      if (request.method == 'GET') {
        return await _challengeController.handleGetChallengeDetails(
          request,
          challengeId: pathSegments[2],
        );
      }

      if (request.method == 'DELETE') {
        return await _challengeController.handleCancelChallenge(
          request,
          challengeId: pathSegments[2],
        );
      }

      return respondWithBadRequest(request);
    }

    // /api/challenge/<id>/{accept|decline}
    if (pathSegments.length == 4) {
      if (request.method == 'GET') {
        if (pathSegments[3] == 'accept') {
          return await _challengeController.handleAcceptChallenge(
            request,
            challengeId: pathSegments[2],
          );
        }

        if (pathSegments[3] == 'decline') {
          return await _challengeController.handleDeclineChallenge(
            request,
            challengeId: pathSegments[2],
          );
        }
      }
    }

    return respondWithBadRequest(request);
  }
}
