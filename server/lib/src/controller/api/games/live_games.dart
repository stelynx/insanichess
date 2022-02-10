import 'dart:io';

import '../../../memory/memory.dart';
import '../../../util/functions/default_responses.dart';

/// Controller that handles API requests regarding live games.
class LiveGamesController {
  /// Constructs new [LiveGamesController] object.
  const LiveGamesController();

  /// Handler for GET number of currently played games.
  ///
  /// Returns number of currently played games.
  ///
  /// The [request] does not need to be authenticated.
  void handleGetNumberOfGamesInProgress(HttpRequest request) {
    return respondWithText(request, memory.gamesInProgress.length);
  }
}
