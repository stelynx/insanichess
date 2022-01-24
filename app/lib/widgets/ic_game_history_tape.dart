import 'package:flutter/cupertino.dart';
import 'package:insanichess/insanichess.dart' as insanichess;

const double _kFontSize = 8;
const double _kGameHistoryTapeHeight = _kFontSize * 3 + 6;

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
    final List<insanichess.PlayedMove> allMoves = List.from(moves);
    allMoves.addAll(movesFromFuture.reversed);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: _kGameHistoryTapeHeight,
        child: Row(
          children: <Widget>[
            for (int i = 0; 2 * i < allMoves.length; i++) ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${i + 1}',
                    style:
                        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              fontSize: _kFontSize,
                              color: CupertinoTheme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                            ),
                  ),
                  Text(
                    allMoves[2 * i].toICString(),
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .copyWith(
                          fontSize: _kFontSize,
                          color: CupertinoTheme.of(context)
                              .primaryColor
                              .withOpacity(2 * i == moves.length - 1 ? 1 : 0.5),
                        ),
                  ),
                  if (2 * i + 1 < allMoves.length)
                    Text(
                      allMoves[2 * i + 1].toICString(),
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                            fontSize: _kFontSize,
                            color: CupertinoTheme.of(context)
                                .primaryColor
                                .withOpacity(
                                    2 * i + 1 == moves.length - 1 ? 1 : 0.5),
                          ),
                    ),
                ],
              ),
              const SizedBox(width: _kFontSize),
            ],
          ],
        ),
      ),
    );
  }
}
