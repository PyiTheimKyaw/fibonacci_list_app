class FibonacciListState {
  List<int> fibonacciList;

  FibonacciListState({required this.fibonacciList});

  FibonacciListState copyWith({List<int>? fibonacciList}) {
    return FibonacciListState(fibonacciList: fibonacciList ?? this.fibonacciList);
  }
}
