enum PieceType { rook, knight, bishop, queen, king, pawn }

extension PieceTypeExtension on PieceType {
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
