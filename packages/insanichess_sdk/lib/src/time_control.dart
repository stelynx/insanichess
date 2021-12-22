class InsanichessTimeControl {
  final Duration initialTime;
  final Duration incrementPerMove;

  const InsanichessTimeControl({
    required this.initialTime,
    required this.incrementPerMove,
  });

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
}
