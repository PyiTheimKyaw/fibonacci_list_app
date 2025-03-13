import '../models/fibonacci_model.dart';

class FibonacciListState {
  List<FibonacciModel> fibonacciList;
  List<FibonacciModel> removedFibonacci;
  FibonacciModel? latestAddedFibonacci;
  FibonacciModel? latestRemovedFibonacci;

  FibonacciListState({
    required this.fibonacciList,
    required this.removedFibonacci,
    this.latestAddedFibonacci,
    this.latestRemovedFibonacci,
  });

  FibonacciListState copyWith({
    List<FibonacciModel>? fibonacciList,
    List<FibonacciModel>? removedFibonacci,
    FibonacciModel? latestAddedFibonacci,
    FibonacciModel? latestRemovedFibonacci,
  }) {
    return FibonacciListState(
      fibonacciList: fibonacciList ?? this.fibonacciList,
      removedFibonacci: removedFibonacci ?? this.removedFibonacci,
      latestAddedFibonacci: latestAddedFibonacci ?? this.latestAddedFibonacci,
      latestRemovedFibonacci: latestRemovedFibonacci ?? this.latestRemovedFibonacci,
    );
  }
}
