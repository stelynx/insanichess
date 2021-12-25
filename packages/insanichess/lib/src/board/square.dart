import 'board.dart';

/// Represents a square on the chessboard.
class Square {
  /// Index of row, between 0 and [Board.size] - 1.
  final int row;

  /// Index of column, between 0 and [Board.size] - 1.
  final int col;

  /// Constructs a new `Square` for [row] and [col].
  const Square(this.row, this.col);

  /// Returns `String` representaion of current square.
  String toICString() => '${'abcdefghijklmnopqrst'[row]}$col';

  @override
  bool operator ==(Object? other) {
    if (other is! Square) return false;
    return row == other.row && col == other.col;
  }

  @override
  int get hashCode => 31 * row.hashCode + col.hashCode;
}
