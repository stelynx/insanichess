import '../pieces/definitions/piece.dart';
import 'square.dart';

/// Represents a move played by a single player.
class Move {
  /// Square [from] where the piece was taken.
  final Square from;

  /// Square [to] where the piece was placed.
  final Square to;

  /// If the piece moved is `Pawn` and it has reached last rank, then this field
  /// holds information to what `Piece` it was promoted.
  final Piece? promotionTo;

  /// Constructs new `Move` object for move [from] square [to] square.
  const Move(this.from, this.to, [this.promotionTo]);

  /// Returns new `Move` object that corresponds to ICString representation [s].
  factory Move.fromICString(String s) {
    final String? promotionTo =
        s[s.length - 1].toLowerCase() == s[s.length - 1].toUpperCase()
            ? null
            : s[s.length - 1];
    final List<String> squares =
        (promotionTo == null ? s : s.substring(0, s.length - 1)).split('-');

    return Move(
      Square.fromICString(squares.first),
      Square.fromICString(squares.last),
      promotionTo == null ? null : Piece.fromFenSymbol(promotionTo),
    );
  }

  /// Returns `String` representaion of the move.
  String toICString() =>
      '${from.toICString()}-${to.toICString()}${promotionTo == null ? '' : promotionTo!.fenSymbol}';

  @override
  bool operator ==(Object? other) {
    if (other is! Move) return false;
    return from == other.from &&
        to == other.to &&
        promotionTo == other.promotionTo;
  }

  @override
  int get hashCode =>
      31 * (31 * from.hashCode + to.hashCode) + promotionTo.hashCode;
}

class PlayedMove extends Move {
  /// A [Piece] that was potentially on the [to] square, or null, if the [to]
  /// square was empty. Used when undoing moves.
  final Piece? pieceOnLandingSquare;

  /// Constructs new `PlayedMove` object for move [from] square [to] square with
  /// info about [pieceOnLandingSquare].
  const PlayedMove(
    Square from,
    Square to,
    this.pieceOnLandingSquare,
    Piece? promotionTo,
  ) : super(from, to, promotionTo);
}
