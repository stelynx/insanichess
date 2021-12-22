class InsanichessTimeControl {
  final Duration initialTime;
  final Duration incrementPerMove;

  const InsanichessTimeControl({
    required this.initialTime,
    required this.incrementPerMove,
  });

  const InsanichessTimeControl.infinite()
      : initialTime = Duration.zero,
        incrementPerMove = Duration.zero;

  bool get isInfinite => initialTime == Duration.zero;
}
