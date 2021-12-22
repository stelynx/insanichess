import 'piece_type.dart';
import 'white_piece.dart';

/// Represent a white queen.
class WhiteQueen extends WhitePiece {
  const WhiteQueen();

  @override
  final PieceType type = PieceType.queen;
}
