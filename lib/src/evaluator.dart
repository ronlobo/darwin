part of darwin;

// TODO: can be implemented as an Isolate
abstract class PhenotypeEvaluator<T extends Phenotype> {
  Object userData;
  Completer _completer;

  /**
   * Evaluate takes the phenotype and returns its fitness score. The lower the
   * fitness score, the better the phenotype. Fitness score of [:0.0:] means
   * that the phenotype is perfect.
   */
  Future<num> evaluate(T phenotype);

  /// Set automatically by [GeneticAlgorithm].
  PrintFunction _printf = print;
}

/**
 * For use when multiple experiments should be done with each phenotype.
 */
abstract class PhenotypeSerialEvaluator<T extends Phenotype>
    extends PhenotypeEvaluator<T> {
  /**
   * Runs one of the experiments to be performed on the given [phenotype].
   * Should complete with the result of the [IterativeFitnessFunction], or with
   * [:null:] when there are no other experiments to run.
   */
  Future<num> runOneEvaluation(T phenotype, int experimentIndex);

  void _next(T phenotype, int experimentIndex) {
    runOneEvaluation(phenotype, experimentIndex).then((num result) {
      if (result == null) {
        _printf("Cummulative result for phenotype: $cummulativeResult");
        _completer.complete(cummulativeResult);
      } else if (result.isInfinite) {
        _printf(
            "Result for experiment #$experimentIndex: FAIL\nFailing phenotype");
        _completer.complete(double.INFINITY);
      } else {
        cummulativeResult += result;
        _printf(
            "Result for experiment: $result (cummulative: $cummulativeResult)");
        _next(phenotype, experimentIndex + 1);
      }
    });
  }

  num cummulativeResult;

  Future<num> evaluate(T phenotype) {
    _printf("Evaluating $phenotype");
    cummulativeResult = 0;
    userData = null;
    _completer = new Completer();
    _next(phenotype, 0);
    return _completer.future;
  }
}
