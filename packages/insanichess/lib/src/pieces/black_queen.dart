import 'black_piece.dart';
import 'piece_type.dart';

/// Represent a black queen.
class BlackQueen extends BlackPiece {
  const BlackQueen();

  @override
  final PieceType type = PieceType.queen;
}
