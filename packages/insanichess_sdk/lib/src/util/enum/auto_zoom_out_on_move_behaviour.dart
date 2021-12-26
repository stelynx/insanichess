import 'package:flutter/foundation.dart';

enum AutoZoomOutOnMoveBehaviour { always, onMyMove, onOpponentMove, never }

extension AutoZoomOutOnMoveBehaviourExtension on AutoZoomOutOnMoveBehaviour {
  String toJson() {
    return describeEnum(this);
  }
}

AutoZoomOutOnMoveBehaviour autoZoomOutOnMoveBehaviourFromJson(String json) {
  return AutoZoomOutOnMoveBehaviour.values
      .firstWhere((AutoZoomOutOnMoveBehaviour el) => describeEnum(el) == json);
}
