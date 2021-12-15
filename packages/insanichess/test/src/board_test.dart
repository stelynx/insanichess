import 'package:flutter_test/flutter_test.dart';
import 'package:insanichess/insanichess.dart';

void main() {
  test('test', () {
    final Board board = Board();
    print(board.toStringAsWhite());
    print(board.toStringAsBlack());

    board.move(const Square(0, 0), const Square(5, 5));

    print(board.toStringAsWhite());
  });
}
