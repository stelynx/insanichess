import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/src/util/extensions/piece_color.dart';

import '../../util/enum/game_event_type.dart';
import '../insanichess_model.dart';

/// Base class for game events.
///
/// Game events are streamed and received on sockets.
abstract class InsanichessGameEvent implements InsanichessModel {
  /// The type of this event. This is used to efficiently parse the game event
  /// data from received json.
  final GameEventType type;

  /// Provides const constructor for implementers.
  const InsanichessGameEvent(this.type);

  /// Creates a concrete implementer of `InsanichessGameEvent` based on the type
  /// provided in json.
  factory InsanichessGameEvent.fromJson(Map<String, dynamic> json) {
    final GameEventType type =
        gameEventTypeFromJson(json[InsanichessGameEventJsonKey.type]);
    switch (type) {
      case GameEventType.movePlayed:
        return MovePlayedGameEvent(
          move: insanichess.Move.fromICString(
            json[InsanichessGameEventJsonKey.movePlayed],
          ),
        );
      case GameEventType.drawOffered:
        return const DrawOfferedGameEvent();
      case GameEventType.resigned:
        return const ResignedGameEvent();
      case GameEventType.undoRequested:
        return const UndoRequestedGameEvent();
      case GameEventType.undoCancelled:
        return const UndoCancelledGameEvent();
      case GameEventType.undoResponse:
        return UndoRespondedGameEvent(
            accept: json[InsanichessGameEventJsonKey.accept]);
    }
  }
}

/// Event that contains data about move that has been played.
class MovePlayedGameEvent extends InsanichessGameEvent {
  /// The [move] that wants to be played or has been played.
  final insanichess.Move move;

  /// Creates new `MovePlayedGameEvent` with [move].
  const MovePlayedGameEvent({required this.move})
      : super(GameEventType.movePlayed);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
      InsanichessGameEventJsonKey.movePlayed: move.toICString()
    };
  }
}

/// Event that can contain data on who offered the draw. When a user sends this
/// event to the server, [player] is empty and is acquired from JWT token. When
/// server broadcasts this event, the [player] is included.
class DrawOfferedGameEvent extends InsanichessGameEvent {
  /// The color of the [player] that offered draw.
  ///
  /// This is only set by the server, therefore clients can send `null` here.
  final insanichess.PieceColor? player;

  /// Creates new `DrawOfferedGameEvent` with the color of the [player].
  const DrawOfferedGameEvent({this.player}) : super(GameEventType.drawOffered);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
      if (player != null) InsanichessGameEventJsonKey.color: player!.toJson(),
    };
  }
}

/// Event that can contain data on who resigned. When a user sends this event
/// to the server, [player] is empty and is acquired from JWT token. When server
/// broadcasts this event, the [player] is included.
class ResignedGameEvent extends InsanichessGameEvent {
  /// The color of the [player] that resigned.
  ///
  /// This is only set by the server, therefore clients can send `null` here.
  final insanichess.PieceColor? player;

  /// Creates new `ResignedGameEvent` with the color of the [player].
  const ResignedGameEvent({this.player}) : super(GameEventType.resigned);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
      if (player != null) InsanichessGameEventJsonKey.color: player!.toJson(),
    };
  }
}

/// Event that a user requested an undo. The event does not contain data of who
/// issued the request, because this is an internal event and is processed only
/// on server side.
class UndoRequestedGameEvent extends InsanichessGameEvent {
  /// Creates new `UndoRequestGameEvent` object.
  const UndoRequestedGameEvent() : super(GameEventType.undoRequested);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
    };
  }
}

/// Event that a user cancelled an undo request. The event does not contain data
/// of who issued the request, because this is an internal event and is
/// processed only on server side.
class UndoCancelledGameEvent extends InsanichessGameEvent {
  /// Creates new `UndoCancelledGameEvent` object.
  const UndoCancelledGameEvent() : super(GameEventType.undoCancelled);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
    };
  }
}

/// Event that a user accepted / declined an undo request. The event does not
/// contain data of who issued the request, because this is an internal event
/// and is processed only on server side. It only contains whether the response
/// is confirming the request or not.
class UndoRespondedGameEvent extends InsanichessGameEvent {
  /// Whether the opponent accepted the undo request or not.
  final bool accept;

  /// Creates new `UndoRespondedGameEvent` object.
  const UndoRespondedGameEvent({required this.accept})
      : super(GameEventType.undoResponse);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
    };
  }
}

/// Provides keys for json representations of different `InsanichessGameEvent`s.
abstract class InsanichessGameEventJsonKey {
  /// Key for `InsanichessGameEvent.type`.
  static const String type = 'type';

  /// Key for `MovePlayedGameEvent.move`.
  static const String movePlayed = 'move';

  /// Key for `DrawOfferedGameEvent.player`, and `ResignedGameEvent.player`.
  static const String color = 'color';

  /// Key for `UndoRespondedGameEvent.accept`.
  static const String accept = 'accept';
}
