import '../pieces/piece.dart';
import 'square.dart';

/// Represents a move played by a single player.
class Move {
  /// Square [from] where the piece was taken.
  final Square from;

  /// Square [to] where the piece was placed.
  final Square to;

  /// A [Piece] that was potentially on the [to] square, or null, if the [to]
  /// square was empty. Used when undoing moves.
  final Piece? pieceOnLandingSquare;

  /// Constructs new `Move` object for move [from] square [to] square with info
  /// about [pieceOnLandingSquare].
  const Move(this.from, this.to, this.pieceOnLandingSquare);

  /// Returns `String` representaion of the move.
  String toICString() => '${from.toICString()}-${to.toICString()}';
}
