/// Automatic board zoom-out behaviour after a move has been played.
enum AutoZoomOutOnMoveBehaviour {
  /// Auto zoom out on every move.
  always,

  /// Auto zoom out when I make a move.
  onMyMove,

  /// Auto zoom out when opponent made a move.
  onOpponentMove,

  /// Never zoom out automatically.
  never,
}

/// Defines additional functions on [AutoZoomOutOnMoveBehaviour].
extension AutoZoomOutOnMoveBehaviourExtension on AutoZoomOutOnMoveBehaviour {
  /// Returns json representation of [AutoZoomOutOnMoveBehaviour].
  int toJson() {
    switch (this) {
      case AutoZoomOutOnMoveBehaviour.always:
        return 3;
      case AutoZoomOutOnMoveBehaviour.never:
        return 0;
      case AutoZoomOutOnMoveBehaviour.onMyMove:
        return 1;
      case AutoZoomOutOnMoveBehaviour.onOpponentMove:
        return 2;
    }
  }
}

/// Returns [AutoZoomOutOnMoveBehaviour] from [json] representation.
AutoZoomOutOnMoveBehaviour autoZoomOutOnMoveBehaviourFromJson(int json) {
  return AutoZoomOutOnMoveBehaviour.values
      .firstWhere((AutoZoomOutOnMoveBehaviour el) => el.toJson() == json);
}
