import 'package:insanichess/insanichess.dart' as insanichess;

import '../../util/enum/game_event_type.dart';
import '../../util/extensions/piece_color.dart';
import '../insanichess_model.dart';

/// Base class for game events.
///
/// Game events are streamed and received on sockets.
///
/// The [type] indicates the type of this game event for efficient parsing from
/// json by either client or server applications.
///
/// The [isBroadcasted] property indicates whether this event should be sent to
/// broadcast stream or not. This property is always set by the server,
/// therefore clients do not need to set it. If they do, it will be ignored by
/// the server.
abstract class InsanichessGameEvent implements InsanichessModel {
  /// The type of this event. This is used to efficiently parse the game event
  /// data from received json.
  final GameEventType type;

  /// Whether this event should be broadcasted or not. Events that are not
  /// broadcasted are only sent to opponent's socket.
  ///
  /// This field is filled in by server so clients do not need to set it. If the
  /// client sets this field, it is ignored by the server and re-set.
  final bool isBroadcasted;

  /// Provides const constructor for implementers.
  const InsanichessGameEvent(this.type, {this.isBroadcasted = false});

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
          timeSpent: json[InsanichessGameEventJsonKey.timeSpent] == null
              ? null
              : Duration(
                  milliseconds: json[InsanichessGameEventJsonKey.timeSpent]),
          player: json[InsanichessGameEventJsonKey.color] == null
              ? null
              : pieceColorFromJson(json[InsanichessGameEventJsonKey.color]),
        );
      case GameEventType.disbanded:
        return const DisbandedGameEvent();
      case GameEventType.drawOffered:
        return const DrawOfferedGameEvent();
      case GameEventType.drawOfferCancelled:
        return const DrawOfferCancelledGameEvent();
      case GameEventType.drawOfferResponded:
        return DrawOfferRespondedGameEvent(
          accept: json[InsanichessGameEventJsonKey.accept],
        );
      case GameEventType.resigned:
        return ResignedGameEvent(
          player: json[InsanichessGameEventJsonKey.color] == null
              ? null
              : pieceColorFromJson(json[InsanichessGameEventJsonKey.color]),
        );
      case GameEventType.flagged:
        return FlaggedGameEvent(
          player: pieceColorFromJson(json[InsanichessGameEventJsonKey.color]),
        );
      case GameEventType.undoRequested:
        return const UndoRequestedGameEvent();
      case GameEventType.undoCancelled:
        return const UndoCancelledGameEvent();
      case GameEventType.undoRequestResponded:
        return UndoRespondedGameEvent(
          accept: json[InsanichessGameEventJsonKey.accept],
        );
    }
  }
}

/// Event that contains data about the [move] that has been played.
///
/// Additionally, server sets [timeSpent] in order for clients to synchronise
/// their clocks. In case these values are set by the client, they are simply
/// ignored.
///
/// This event is always broadcasted because subscribers of the broadcast stream
/// must know that a move has been played. This event is also sent back to the
/// same player that sent it initially so that he can sync his clock.
class MovePlayedGameEvent extends InsanichessGameEvent {
  /// The [move] that wants to be played or has been played.
  final insanichess.Move move;

  /// The time the player has spent for the [move].
  final Duration? timeSpent;

  /// The color of the player that made the move.
  final insanichess.PieceColor? player;

  /// Creates new `MovePlayedGameEvent` with [move] and optional [timeSpent] for
  /// this move. The server always sets [timeSpent] but if client sets it, it is
  /// simply ignored by the server.
  const MovePlayedGameEvent({
    required this.move,
    this.timeSpent,
    this.player,
  }) : super(GameEventType.movePlayed, isBroadcasted: true);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
      InsanichessGameEventJsonKey.movePlayed: move.toICString(),
      if (timeSpent != null)
        InsanichessGameEventJsonKey.timeSpent: timeSpent!.inMilliseconds,
      if (player != null) InsanichessGameEventJsonKey.color: player!.toJson(),
    };
  }
}

/// Event that signals that white player did not make a move in the initial time
/// period.
///
/// This event is only triggered by server to notify listeners on sockets that a
/// game has been disbanded.
class DisbandedGameEvent extends InsanichessGameEvent {
  /// Creates new [DisbandedGameEvent] object.
  const DisbandedGameEvent() : super(GameEventType.disbanded);

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
    };
  }
}

/// Event that signals a draw offer. This event is not sent on the broadcast
/// stream, therefore no need to have a player as a field here.
class DrawOfferedGameEvent extends InsanichessGameEvent {
  /// Creates new `DrawOfferedGameEvent` object.
  const DrawOfferedGameEvent() : super(GameEventType.drawOffered);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
    };
  }
}

/// Event that signals a draw offer has been revoked. This event is not sent on
/// the broadcast stream, therefore no need to have a player as a field here.
class DrawOfferCancelledGameEvent extends InsanichessGameEvent {
  /// Creates new `DrawOfferCancelledGameEvent` object.
  const DrawOfferCancelledGameEvent() : super(GameEventType.drawOfferCancelled);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
    };
  }
}

/// Event that a user accepted / declined a draw offer. The event does not
/// contain data of who issued the request, because this is an internal event
/// and is processed only on server side. It only contains whether the response
/// is confirming the request or not.
///
/// This event is only broadcasted if it is accepting a draw because subscribers
/// of broadcast stream must know that a game has ended and resulted in a draw.
class DrawOfferRespondedGameEvent extends InsanichessGameEvent {
  /// Whether the opponent accepted a draw offer or not.
  final bool accept;

  /// Creates new [DrawOfferRespondedGameEvent] object.
  const DrawOfferRespondedGameEvent({required this.accept})
      : super(GameEventType.drawOfferResponded, isBroadcasted: accept);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
      InsanichessGameEventJsonKey.accept: accept,
    };
  }
}

/// Event that can contain data on who resigned. When a user sends this event
/// to the server, [player] is empty and is acquired from JWT token. When server
/// broadcasts this event, the [player] is included.
///
/// This event is always broadcasted because subscribers need to know that the
/// game ended and a [player] that resigned.
class ResignedGameEvent extends InsanichessGameEvent {
  /// The color of the [player] that resigned.
  ///
  /// This is only set by the server, therefore clients can send `null` here.
  final insanichess.PieceColor? player;

  /// Creates new `ResignedGameEvent` with the color of the [player]. This event
  /// is always broadcasted because subscribers of the broadcast stream must
  /// know that a game has ended and who resigned.
  const ResignedGameEvent({this.player})
      : super(GameEventType.resigned, isBroadcasted: true);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
      if (player != null) InsanichessGameEventJsonKey.color: player!.toJson(),
    };
  }
}

/// Event that can contains data on who flagged.
///
/// This event can only be issued by the server and should not be used by client
/// applications.
///
/// This event is always broadcasted because subscribers need to know that the
/// game ended and a [player] was flagged.
class FlaggedGameEvent extends InsanichessGameEvent {
  /// The color of the [player] that ran out of time.
  ///
  /// This property can also be deduced from current game state, however due to
  /// simplicity we keep it here as well.
  final insanichess.PieceColor player;

  /// Creates new [FlaggedGameEvent] with the color of the [player]. This event
  /// is always broadcasted because subscribers of the broadcast stream must
  /// know that a game has ended and who ran out of time.
  const FlaggedGameEvent({required this.player})
      : super(GameEventType.flagged, isBroadcasted: true);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
      InsanichessGameEventJsonKey.color: player.toJson(),
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
///
/// This event is broadcasted only if it is accepting the undo request, because
/// subscribers of the broadcast stream need to know that move has been undone.
class UndoRespondedGameEvent extends InsanichessGameEvent {
  /// Whether the opponent accepted the undo request or not.
  final bool accept;

  /// Creates new `UndoRespondedGameEvent` object.
  const UndoRespondedGameEvent({required this.accept})
      : super(GameEventType.undoRequestResponded, isBroadcasted: accept);

  /// Converts this object to json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      InsanichessGameEventJsonKey.type: type.toJson(),
      InsanichessGameEventJsonKey.accept: accept,
    };
  }
}

/// Provides keys for json representations of different [InsanichessGameEvent]s.
abstract class InsanichessGameEventJsonKey {
  /// Key for [InsanichessGameEvent.type].
  static const String type = 'type';

  /// Key for [MovePlayedGameEvent.move].
  static const String movePlayed = 'move';

  /// Key for [MovePlayedGameEvent.timeSpent].
  static const String timeSpent = 'time';

  /// Key for [DrawOfferedGameEvent.player], [FlaggedGameEvent.player],
  /// [ResignedGameEvent.player], and [MovePlayedGameEvent.player].
  static const String color = 'color';

  /// Key for [UndoRespondedGameEvent.accept], and
  /// [DrawOfferRespondedGameEvent.accept].
  static const String accept = 'accept';
}
