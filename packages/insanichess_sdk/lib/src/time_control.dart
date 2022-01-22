/// Represents a time control for a game.
class InsanichessTimeControl {
  /// Initial time on the clock, in seconds.
  final Duration initialTime;

  /// Increment that a player receives after each move, in seconds.
  final Duration incrementPerMove;

  /// Creates new [InsanichessTimeControl] object with [initialTime] and
  /// [incrementPerMove]. All values are in seconds.
  const InsanichessTimeControl({
    required this.initialTime,
    required this.incrementPerMove,
  });

  /// Creates new [InsanichessTimeControl] object from [json] representation.
  InsanichessTimeControl.fromJson(Map<String, dynamic> json)
      : initialTime =
            Duration(seconds: json[InsanichessTimeControlJsonKey.initialTime]),
        incrementPerMove =
            Duration(seconds: json[InsanichessTimeControlJsonKey.increment]);

  /// Creates new [InsanichessTimeControl] object with default blitz settings.
  const InsanichessTimeControl.blitz()
      : initialTime = const Duration(minutes: 5),
        incrementPerMove = Duration.zero;

  /// Creates new [InsanichessTimeControl] object with default rapid settings.
  const InsanichessTimeControl.rapid()
      : initialTime = const Duration(minutes: 10),
        incrementPerMove = Duration.zero;

  /// Creates new [InsanichessTimeControl] object representing that game is not
  /// bounded by time.
  ///
  /// This setting has no effect for now.
  const InsanichessTimeControl.infinite()
      : initialTime = Duration.zero,
        incrementPerMove = Duration.zero;

  /// Returns `true` if this time control is infinite.
  bool get isInfinite => initialTime == Duration.zero;

  /// Converts this object into json representation.
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
