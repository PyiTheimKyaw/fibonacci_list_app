import 'package:fibonacci_list_app/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/fibonacci_notifier.dart';
import '../utils/enums.dart';

class FibonacciListPage extends ConsumerStatefulWidget {
  const FibonacciListPage({super.key});

  @override
  ConsumerState<FibonacciListPage> createState() => _FibonacciListPageState();
}

class _FibonacciListPageState extends ConsumerState<FibonacciListPage> {
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

  @override
  Widget build(BuildContext context) {
    final fibonacciNumbers = ref.watch(fibonacciProvider).fibonacciList;

    return Scaffold(
      appBar: AppBar(title: Text("Fibonacci List"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(fibonacciNumbers.length, (index) {
            final number = fibonacciNumbers[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: kMargin16, vertical: kMargin18),
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("Index : $index, Number : $number"), Spacer(), _getSymbolIcon(getSymbolType(number))],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _getSymbolIcon(SymbolType type) {
    switch (type) {
      case SymbolType.square:
        return Icon(Icons.crop_square);
      case SymbolType.circle:
        return Icon(Icons.circle);
      case SymbolType.cross:
        return Icon(Icons.close);
    }
  }
}
