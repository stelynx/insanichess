import 'board.dart';

/// Represents a square on the chessboard.
class Square {
  /// Index of row, between 0 and [Board.size] - 1.
  final int row;

  /// Index of column, between 0 and [Board.size] - 1.
  final int col;

  /// Constructs a new `Square` for [row] and [col].
  const Square(this.row, this.col);

  /// Constructs new `Square` that corresponds to ICString representation [s].
  Square.fromICString(String s)
      : row = int.parse(s.substring(1)) - 1,
        col = 'abcdefghijklmnopqrst'.indexOf(s[0]);

  /// Returns `String` representaion of current square.
  String toICString() => '${'abcdefghijklmnopqrst'[col]}${row + 1}';

  @override
  bool operator ==(Object? other) {
    if (other is! Square) return false;
    return row == other.row && col == other.col;
  }

  @override
  int get hashCode => 31 * row.hashCode + col.hashCode;
}
