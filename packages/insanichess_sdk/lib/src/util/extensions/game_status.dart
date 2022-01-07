import 'package:insanichess/insanichess.dart' as insanichess;

extension GameStatusExtension on insanichess.GameStatus {
  String toJson() {
    switch (this) {
      case insanichess.GameStatus.notStarted:
        return 'not_started';
      case insanichess.GameStatus.playing:
        return 'play';
      case insanichess.GameStatus.draw:
        return 'draw';
      case insanichess.GameStatus.whiteWon:
        return 'w';
      case insanichess.GameStatus.blackWon:
        return 'b';
    }
  }
}

insanichess.GameStatus gameStatusFromJson(String s) =>
    insanichess.GameStatus.values.firstWhere(
        (insanichess.GameStatus gameStatus) => gameStatus.toJson() == s);
