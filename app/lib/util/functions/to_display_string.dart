import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';

String timeControlToDisplayString(InsanichessTimeControl timeControl) {
  if (timeControl.isInfinite) return '∞';

  String s = '';

  final int minutes = timeControl.initialTime.inMinutes;
  if (minutes > 0) s += '$minutes min';

  final int seconds =
      (timeControl.initialTime - Duration(minutes: minutes)).inSeconds;
  if (seconds > 0) {
    if (minutes > 0) s += ' ';
    s += '$seconds s';
  }

  final int incrementSeconds = timeControl.incrementPerMove.inSeconds;
  if (incrementSeconds > 0) s += ' + $incrementSeconds s';

  return s;
}

String preferredColorToDisplayString(insanichess.PieceColor? color) {
  return color == insanichess.PieceColor.white
      ? 'White'
      : color == insanichess.PieceColor.black
          ? 'Black'
          : 'Any';
}
