import 'package:insanichess/insanichess.dart' as insanichess;

insanichess.Position positionFromFen(String fen) {
  final List<String> rowsAsString = fen.split('/');

  final insanichess.Position position = List<List<insanichess.Piece?>>.filled(
    insanichess.Board.size,
    List<insanichess.Piece?>.filled(
      insanichess.Board.size,
      null,
      growable: false,
    ),
    growable: false,
  );

  for (int r = 0; r < insanichess.Board.size; r++) {
    for (int c = 0; c < insanichess.Board.size; c++) {
      if (rowsAsString[r][c] == '*') continue;

      position[r][c] = insanichess.Piece.fromFenSymbol(rowsAsString[r][c]);
    }
  }

  return position;
}
