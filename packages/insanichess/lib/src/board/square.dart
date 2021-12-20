class Square {
  final int row;
  final int col;

  const Square(this.row, this.col);

  String toICString() => '${'abcdefghijklmnopqrst'[row]}$col';

  @override
  String toString() => toICString();
}
