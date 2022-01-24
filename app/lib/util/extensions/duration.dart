extension DurationExtension on Duration {
  String toClockString() {
    final int minutes = inMinutes;
    final int seconds = inSeconds;
    final int milliseconds = inMilliseconds;

    final String minStr = '$minutes';
    final String secStr = '0${seconds % 60}';
    final String milStr = '0${milliseconds % 10000}';

    return '$minStr:${secStr.substring(secStr.length - 2)}${seconds < 10 ? '.${milStr.substring(milStr.length - 2)}' : ''}';
  }
}
