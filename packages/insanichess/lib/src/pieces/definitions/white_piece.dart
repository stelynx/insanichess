import 'piece.dart';
import 'piece_color.dart';

/// Abstraction that extends [Piece] by setting the color to [PieceColor.white].
abstract class WhitePiece extends Piece {
  /// Const constructor for overrided members to be able to have const
  /// constructors.
  const WhitePiece();

  @override
  final PieceColor color = PieceColor.white;

  @override
  final bool isWhite = true;

  @override
  final bool isBlack = false;
}
