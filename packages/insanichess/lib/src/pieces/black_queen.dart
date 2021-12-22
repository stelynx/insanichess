import 'definitions/black_piece.dart';
import 'definitions/piece_type.dart';
import 'mixins/queen.dart';

/// Represent a black queen.
class BlackQueen extends BlackPiece with Queen {
  const BlackQueen();

  @override
  final PieceType type = PieceType.queen;
}
