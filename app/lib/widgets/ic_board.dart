import 'package:flutter/cupertino.dart';
import 'package:insanichess/insanichess.dart' as insanichess;

import '../style/colors.dart';

class ICBoard extends StatelessWidget {
  final insanichess.Board board;
  final bool asWhite;

  const ICBoard({
    Key? key,
    required this.board,
    this.asWhite = true,
  }) : super(key: key);

  Widget _generateSquare(int row, int col, {required BuildContext context}) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxSquareSize = (screenSize.width < screenSize.height
            ? screenSize.width
            : screenSize.height) /
        insanichess.Board.size;

    return Container(
      height: maxSquareSize, // might change
      width: maxSquareSize, // might change
      constraints: BoxConstraints(
        maxHeight: maxSquareSize,
        maxWidth: maxSquareSize,
      ),
      decoration: BoxDecoration(
        color: (row + col) % 2 == 0
            ? ICColor.chessboardWhite
            : ICColor.chessboardBlack,
      ),
      child: Center(
        child: Text(
          board.at(row, col)?.fenSymbol ?? '',
          style: TextStyle(fontSize: maxSquareSize - 4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> rows = <Row>[];

    if (asWhite) {
      for (int row = insanichess.Board.size - 1; row >= 0; row--) {
        final List<Widget> children = <Widget>[];
        for (int col = 0; col < insanichess.Board.size; col++) {
          children.add(_generateSquare(row, col, context: context));
        }
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ));
      }
    } else {
      for (int row = 0; row < insanichess.Board.size; row++) {
        final List<Widget> children = <Widget>[];
        for (int col = insanichess.Board.size - 1; col >= 0; col--) {
          children.add(_generateSquare(row, col, context: context));
        }
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ));
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows,
    );
  }
}
