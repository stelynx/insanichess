import '../pieces/definitions/piece.dart';
import 'square.dart';

/// Represents a move played by a single player.
class Move {
  /// Square [from] where the piece was taken.
  final Square from;

  /// Square [to] where the piece was placed.
  final Square to;

  /// Constructs new `Move` object for move [from] square [to] square.
  const Move(this.from, this.to);

  /// Returns `String` representaion of the move.
  String toICString() => '${from.toICString()}-${to.toICString()}';
}

class PlayedMove extends Move {
  /// A [Piece] that was potentially on the [to] square, or null, if the [to]
  /// square was empty. Used when undoing moves.
  final Piece? pieceOnLandingSquare;

  /// Constructs new `PlayedMove` object for move [from] square [to] square with
  /// info about [pieceOnLandingSquare].
  const PlayedMove(Square from, Square to, this.pieceOnLandingSquare)
      : super(from, to);
}
