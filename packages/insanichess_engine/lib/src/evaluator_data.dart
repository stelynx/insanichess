import 'dart:isolate';

import 'package:insanichess/insanichess.dart' as insanichess;

/// All data needed by the evaluator.
class EvaluatorData {
  final insanichess.Position position;
  final insanichess.PieceColor playerOnMove;
  final bool whiteHasRightToCastle;
  final bool blackHasRightToCastle;

  /// Constructs new `EvaluatorData` object with [position], [playerOnMove],
  /// [whiteHasRightToCastle], and [blackHasRightToCastle].
  const EvaluatorData({
    required this.position,
    required this.playerOnMove,
    required this.whiteHasRightToCastle,
    required this.blackHasRightToCastle,
  });
}

/// All data needed by the live evaluator.
class LiveEvaluatorData extends EvaluatorData {
  final SendPort sendPort;

  /// Constructs new `LiveEvaluatorData`.
  const LiveEvaluatorData({
    required this.sendPort,
    required insanichess.Position position,
    required insanichess.PieceColor playerOnMove,
    required bool whiteHasRightToCastle,
    required bool blackHasRightToCastle,
  }) : super(
          position: position,
          playerOnMove: playerOnMove,
          whiteHasRightToCastle: whiteHasRightToCastle,
          blackHasRightToCastle: blackHasRightToCastle,
        );
}
