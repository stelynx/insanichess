/// Status of the game.
enum GameStatus {
  /// The game has not started yet. Position can either be initial or custom.
  notStarted,

  /// The game is in progress.
  playing,

  /// Players have agreed to a draw and the game is over. Since there is no
  /// concept of stalemate, this is the only option for this status.
  draw,

  /// White has taken black's king and the game is over.
  whiteCheckmated,

  /// Black has taken white's king and the game is over.
  blackCheckmated,

  /// White has lost on time and the game is over.
  whiteFlagged,

  /// Black has lost on time and the game is over.
  blackFlagged,

  /// White has resigned and the game is over.
  whiteResigned,

  /// Black has resigned and the game is over.
  blackResigned,
}
