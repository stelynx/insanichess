class InsanichessTimeControl {
  final Duration initialTime;
  final Duration incrementPerMove;

  const InsanichessTimeControl({
    required this.initialTime,
    required this.incrementPerMove,
  });

  InsanichessTimeControl.fromJson(Map<String, dynamic> json)
      : initialTime =
            Duration(seconds: json[InsanichessTimeControlJsonKey.initialTime]),
        incrementPerMove =
            Duration(seconds: json[InsanichessTimeControlJsonKey.increment]);

  const InsanichessTimeControl.blitz()
      : initialTime = const Duration(minutes: 5),
        incrementPerMove = Duration.zero;

  const InsanichessTimeControl.rapid()
      : initialTime = const Duration(minutes: 10),
        incrementPerMove = Duration.zero;

  const InsanichessTimeControl.infinite()
      : initialTime = Duration.zero,
        incrementPerMove = Duration.zero;

  bool get isInfinite => initialTime == Duration.zero;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessTimeControlJsonKey.initialTime: initialTime.inSeconds,
      InsanichessTimeControlJsonKey.increment: incrementPerMove.inSeconds,
    };
  }
}

/// Keys used in `InsanichessTimeControl` json representations.
abstract class InsanichessTimeControlJsonKey {
  /// Key for `InsanichessTimeControl.initialTime`.
  static const String initialTime = 'initial';

  /// Key for `InsanichessTimeControl.increment`.
  static const String increment = 'inc';
}
