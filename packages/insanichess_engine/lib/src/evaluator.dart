import 'evaluator_data.dart';

/// Provides evaluation function [evaluate].
///
/// The difference between `InsanichessEvaluator` and `InsanichessLiveEvaluator`
/// is that this function needs to be called manually every time to evaluate a
/// position.
abstract class InsanichessEvaluator {
  const InsanichessEvaluator();

  /// Returns evaluation based on current game factors.
  static double evaluate(EvaluatorData data) {
    return 0;
  }
}
