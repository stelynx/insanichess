enum AutoZoomOutOnMoveBehaviour { always, onMyMove, onOpponentMove, never }

extension AutoZoomOutOnMoveBehaviourExtension on AutoZoomOutOnMoveBehaviour {
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

AutoZoomOutOnMoveBehaviour autoZoomOutOnMoveBehaviourFromJson(int json) {
  return AutoZoomOutOnMoveBehaviour.values
      .firstWhere((AutoZoomOutOnMoveBehaviour el) => el.toJson() == json);
}
