import 'package:fibonacci_list_app/notifier/fibonacci_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Notifier class to notify the state changes to the view layer(Widgets)
class FibonacciNotifier extends StateNotifier<FibonacciListState> {
  FibonacciNotifier({int count = 40}) : super(FibonacciListState(fibonacciList: [])) {
    generateFibonacci(count);
  }

  ///func for 40 Fibonacci numbers.
  void generateFibonacci(int count) {
    List<int> fib = [0, 1];
    for (int i = 2; i <= count; i++) {
      fib.add(fib[i - 1] + fib[i - 2]);
    }
    state = state.copyWith(fibonacciList: fib);
  }
}

// State Management - Riverpod Provider
final fibonacciProvider = StateNotifierProvider<FibonacciNotifier, FibonacciListState>((ref) {
  return FibonacciNotifier();
});
