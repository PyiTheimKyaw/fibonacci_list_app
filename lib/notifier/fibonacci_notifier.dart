import 'package:fibonacci_list_app/notifier/fibonacci_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/fibonacci_model.dart';
import '../utils/enums.dart';

///Notifier class to notify the state changes to the view layer(Widgets)
class FibonacciNotifier extends StateNotifier<FibonacciListState> {
  FibonacciNotifier({int count = 40})
    : super(FibonacciListState(fibonacciList: List.filled(41, FibonacciModel(0, 0)), removedFibonacci: [])) {
    generateFibonacci(count);
  }

  ///func for 40 Fibonacci numbers.
  void generateFibonacci(int count) {
    List<int> fib = [0, 1];
    List<FibonacciModel> list = [FibonacciModel(0, 0), FibonacciModel(1, 1)];

    for (int i = 2; i <= count; i++) {
      int fibValue = fib[i - 1] + fib[i - 2];
      fib.add(fibValue);
      list.add(FibonacciModel(i, fibValue));
    }

    state = state.copyWith(fibonacciList: list);
  }

  void onTapRemoveNumber({required int index}) {
    FibonacciModel? removedFibonacci = state.fibonacciList[index];
    state.fibonacciList.removeAt(index);
    state.removedFibonacci.add(removedFibonacci);
    state.removedFibonacci.sort((a, b) => a.index.compareTo(b.index));
    state = state.copyWith(latestRemovedFibonacci: removedFibonacci);
  }

  SymbolType getSymbolType(int number) {
    switch (number % 3) {
      case 0:
        return SymbolType.circle;
      case 1:
        return SymbolType.square;
      case 2:
        return SymbolType.cross;
      default:
        return SymbolType.circle;
    }
  }

  void onTapAddNumber({required int index, required SymbolType selectedItemType}) {
    FibonacciModel? addedFibonacci =
        state.removedFibonacci.where((e) => getSymbolType(e.number) == selectedItemType).toList()[index];
    state.removedFibonacci.remove(addedFibonacci);
    state.fibonacciList.add(addedFibonacci);
    state.fibonacciList.sort((a, b) => a.index.compareTo(b.index));
    state = state.copyWith(latestAddedFibonacci: addedFibonacci);
  }
}

// State Management - Riverpod Provider
final fibonacciProvider = StateNotifierProvider.autoDispose<FibonacciNotifier, FibonacciListState>((ref) {
  return FibonacciNotifier();
});
