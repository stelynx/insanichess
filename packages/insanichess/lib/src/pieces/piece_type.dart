import 'piece.dart';

/// Represents a type of the [Piece].
enum PieceType { rook, knight, bishop, queen, king, pawn }

extension PieceTypeExtension on PieceType {
  /// Returns FEN symbol for the given piece type. The returned values are for
  /// black pieces, for white you have to transform the [fenSymbol] to upper
  /// case letter.
  String get fenSymbol {
    switch (this) {
      case PieceType.bishop:
        return 'b';
      case PieceType.king:
        return 'k';
      case PieceType.knight:
        return 'n';
      case PieceType.pawn:
        return 'p';
      case PieceType.queen:
        return 'q';
      case PieceType.rook:
        return 'r';
    }
  }
}
