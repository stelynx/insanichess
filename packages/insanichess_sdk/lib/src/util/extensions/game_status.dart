import 'package:insanichess/insanichess.dart' as insanichess;

extension GameStatusExtension on insanichess.GameStatus {
  int toJson() {
    switch (this) {
      case insanichess.GameStatus.notStarted:
        return 0;
      case insanichess.GameStatus.playing:
        return 1;
      case insanichess.GameStatus.draw:
        return 2;
      case insanichess.GameStatus.whiteCheckmated:
        return 3;
      case insanichess.GameStatus.blackCheckmated:
        return 4;
      case insanichess.GameStatus.whiteFlagged:
        return 5;
      case insanichess.GameStatus.blackFlagged:
        return 6;
      case insanichess.GameStatus.whiteResigned:
        return 7;
      case insanichess.GameStatus.blackResigned:
        return 8;
    }
  }
}

insanichess.GameStatus gameStatusFromJson(int json) =>
    insanichess.GameStatus.values.firstWhere(
        (insanichess.GameStatus gameStatus) => gameStatus.toJson() == json);
