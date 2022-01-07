enum AutoZoomOutOnMoveBehaviour { always, onMyMove, onOpponentMove, never }

extension AutoZoomOutOnMoveBehaviourExtension on AutoZoomOutOnMoveBehaviour {
  String toJson() {
    switch (this) {
      case AutoZoomOutOnMoveBehaviour.always:
        return 'always';
      case AutoZoomOutOnMoveBehaviour.never:
        return 'never';
      case AutoZoomOutOnMoveBehaviour.onMyMove:
        return 'my_move';
      case AutoZoomOutOnMoveBehaviour.onOpponentMove:
        return 'opponent_move';
    }
  }
}

AutoZoomOutOnMoveBehaviour autoZoomOutOnMoveBehaviourFromJson(String json) {
  return AutoZoomOutOnMoveBehaviour.values
      .firstWhere((AutoZoomOutOnMoveBehaviour el) => el.toJson() == json);
}
