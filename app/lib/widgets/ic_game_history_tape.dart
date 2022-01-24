import 'package:flutter/cupertino.dart';
import 'package:insanichess/insanichess.dart' as insanichess;

const double _kGameHistoryTapeHeight = 20;
const EdgeInsets _kPadding = EdgeInsets.symmetric(vertical: 2);

class ICGameHistoryTape extends StatelessWidget {
  final List<insanichess.PlayedMove> moves;
  final List<insanichess.PlayedMove> movesFromFuture;

  const ICGameHistoryTape({
    Key? key,
    required this.moves,
    required this.movesFromFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double textHeight = _kGameHistoryTapeHeight - 2 * _kPadding.bottom;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: _kGameHistoryTapeHeight,
      ),
    );
  }
}
