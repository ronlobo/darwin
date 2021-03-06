darwin
======

A genetic algorithm library for Dart. 

Example use:

```dart
// Create first generation, either by random or by continuing with existing
// progress.
var firstGeneration = new Generation<MyPhenotype>()
  ..members.addAll([/*...*/]);

// Evaluators take each phenotype and assign a fitness value to it according
// to some fitness function.
var evaluator = new MyEvaluator();

// Breeders are in charge of creating new generations from previous ones (that
// have been graded by the evaluator). Their only required argument is
// a function that returns a blank phenotype.
var breeder = new GenerationBreeder(() => new MyPhenotype())
  ..crossoverPropability = 0.8;

var algo = new GeneticAlgorithm(firstGeneration, evaluator, breeder);

// Start the algorithm.
algo.runUntilDone()
.then((_) {
  // Print all members of the last generation when done.
  algo.generations.last.members
    .forEach((Phenotype ph) => print("${ph.genesAsString}"));
});
```

See `test/unittest.dart` for examples of subclassing Phenotype and Evaluator.