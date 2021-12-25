import 'piece.dart';
import 'piece_color.dart';

/// Abstraction that extends [Piece] by setting the color to [PieceColor.black].
abstract class BlackPiece extends Piece {
  /// Const constructor for overrided members to be able to have const
  /// constructors.
  const BlackPiece();

  @override
  final PieceColor color = PieceColor.black;

  @override
  final bool isWhite = false;

  @override
  final bool isBlack = true;
}
