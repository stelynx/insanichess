/// The type of the game event. This is used to indicate what kind of data is in
/// the request / response and to be able to efficiently parse the data.
enum GameEventType {
  /// Event represents a move played.
  movePlayed,

  /// Event represents a draw offer.
  drawOffered,

  /// Event represents that a draw offer has been cancelled.
  drawOfferCancelled,

  /// Event represents a player's response to the draw offer.
  drawOfferResponded,

  /// Event signaling a user resigned.
  resigned,

  /// Event represents that a player requested an undo.
  undoRequested,

  /// Event represents that a player cancelled undo request.
  undoCancelled,

  /// Event represents a player's response to the undo request.
  undoRequestResponded,
}

extension GameEventTypeExtension on GameEventType {
  String toJson() {
    switch (this) {
      case GameEventType.movePlayed:
        return 'move';
      case GameEventType.drawOffered:
        return 'draw_offer';
      case GameEventType.drawOfferCancelled:
        return 'draw_cancel';
      case GameEventType.drawOfferResponded:
        return 'draw_response';
      case GameEventType.resigned:
        return 'resign';
      case GameEventType.undoRequested:
        return 'undo_req';
      case GameEventType.undoCancelled:
        return 'undo_cancel';
      case GameEventType.undoRequestResponded:
        return 'undo_res';
    }
  }
}

GameEventType gameEventTypeFromJson(String json) {
  return GameEventType.values
      .firstWhere((GameEventType type) => type.toJson() == json);
}
