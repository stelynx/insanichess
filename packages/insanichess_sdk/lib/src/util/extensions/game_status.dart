import 'package:flutter/foundation.dart';
import 'package:insanichess/insanichess.dart' as insanichess;

extension GameStatusExtension on insanichess.GameStatus {
  String toJson() => describeEnum(this);
}

insanichess.GameStatus gameStatusFromJson(String s) =>
    insanichess.GameStatus.values.firstWhere(
        (insanichess.GameStatus gameStatus) => describeEnum(gameStatus) == s);
