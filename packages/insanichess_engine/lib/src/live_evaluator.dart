import 'dart:async';
import 'dart:isolate';

import 'package:insanichess/insanichess.dart' as insanichess;

import 'evaluator.dart';
import 'evaluator_data.dart';

/// Holds all the necessary data for evaluation and provides ability to evaluate
/// the position given different factors.
///
/// This class is meant to be used as a live evaluator, meaning all game logic
/// operations have to be performed on the object itself. All of the performed
/// operations are unsafe, meaning no checks are being performed and everything
/// is blindly executed due to performance improvements.
///
/// The evaluation is performed in an `Isolate` and is then streamed back to the
/// client on [evaluationStream].
class InsanichessLiveEvaluator {
  /// Current position.
  final insanichess.Position _position;

  /// Player that has next move.
  insanichess.PieceColor _playerOnMove;

  /// Whether white has right to castle. The right is lost if the king is moved.
  bool _whiteHasRightToCastle;

  /// Whether black has right to castle. The right is lost if the king is moved.
  bool _blackHasRightToCastle;

  /// Stream controller whose stream is exposed as [evaluationStream].
  final StreamController<double> _evaluationStreamController;

  /// A port on which data is received from the compute [_isolate].
  final ReceivePort _isolatePort;

  /// Everytime an evaluation is needed, a new [_isolate] is created.
  Isolate? _isolate;

  /// Stream subscription for [_isolatePort]. The stream listener forwards data
  /// incoming from [_isolatePort] to [_evaluationStreamController].
  late final StreamSubscription<dynamic> _isolatePortSubscription;

  /// Isolate name for debugging purposes.
  static const String _isolateName = 'ICLiveEvaluator evaluation isolate';

  /// Receiving port name for debugging purposes.
  static const String _isolatePortName = '$_isolateName port';

  /// Creates a new `ICLiveEvaluator` object with given [position],
  /// [playerOnMove], [whiteHasRightToCastle], and [blackHasRightToCastle].
  /// All parameters are required.
  InsanichessLiveEvaluator({
    required insanichess.Position position,
    required insanichess.PieceColor playerOnMove,
    required bool whiteHasRightToCastle,
    required bool blackHasRightToCastle,
  })  : _position = position,
        _playerOnMove = playerOnMove,
        _whiteHasRightToCastle = whiteHasRightToCastle,
        _blackHasRightToCastle = blackHasRightToCastle,
        _evaluationStreamController = StreamController<double>.broadcast(),
        _isolatePort = ReceivePort(_isolatePortName) {
    _isolatePortSubscription = _isolatePort.listen((dynamic message) {
      if (message is double) {
        _evaluationStreamController.add(message);
      }
    });
  }

  /// Cancels all subscriptions and destroys isolate and ports.
  ///
  /// **Must** always be called when the evaluator is no longer needed.
  Future<void> destroy() async {
    await _isolatePortSubscription.cancel();
    _isolatePort.close();
    _isolate?.kill();
  }

  /// Returns the stream on which evaluations are streamed.
  Stream<double> get evaluationStream => _evaluationStreamController.stream;

  /// Performs blind move on the current position and updates necessary values.
  ///
  /// This method is **not meant to be awaited**.
  Future<void> move(insanichess.Square from, insanichess.Square to) async {
    _position[to.row][to.col] = _position[from.row][from.col];
    _position[from.row][from.col] = null;
    if (_playerOnMove == insanichess.PieceColor.white) {
      _whiteHasRightToCastle = _whiteHasRightToCastle &&
          _position[from.row][from.col]?.type != insanichess.PieceType.king;
      _playerOnMove = insanichess.PieceColor.black;
    } else {
      _blackHasRightToCastle = _blackHasRightToCastle &&
          _position[from.row][from.col]?.type != insanichess.PieceType.king;
      _playerOnMove = insanichess.PieceColor.white;
    }
    _startEvaluation();
  }

  /// Immediately kills the [_isolate] if not null and sets it to `null`.
  void _killIsolate() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  /// Starts evaluation.
  Future<void> _startEvaluation() async {
    _killIsolate();

    try {
      _isolate = await Isolate.spawn<LiveEvaluatorData>(
        _evaluate,
        LiveEvaluatorData(
          sendPort: _isolatePort.sendPort,
          position: _position,
          playerOnMove: _playerOnMove,
          whiteHasRightToCastle: _whiteHasRightToCastle,
          blackHasRightToCastle: _blackHasRightToCastle,
        ),
        debugName: _isolateName,
      );
      _isolatePort.listen((message) {});
    } catch (_) {
      _killIsolate();
    }
  }

  /// The main evaluator. It uses `ICEvaluator.evaluate(data)` in the background
  /// and sends the result to the [_isolatePort].
  static void _evaluate(LiveEvaluatorData data) {
    data.sendPort.send(InsanichessEvaluator.evaluate(data));
  }
}
