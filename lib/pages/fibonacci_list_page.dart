import 'package:fibonacci_list_app/models/fibonacci_model.dart';
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
  late FibonacciNotifier fibonacciNotifier;
  final Map<int, GlobalKey> _mainListItemKeys = {};
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerForBottomSheet = ScrollController();

  final Map<int, GlobalKey> _bottomSheetListItemKeys = {};

  @override
  void initState() {
    fibonacciNotifier = ref.read(fibonacciProvider.notifier);
    super.initState();
  }

  void _scrollToLatestRemoved() {
    final latestRemoved = ref.watch(fibonacciProvider).latestRemovedFibonacci;
    if (latestRemoved != null && _bottomSheetListItemKeys.containsKey(latestRemoved.index)) {
      final key = _bottomSheetListItemKeys[latestRemoved.index];

      if (key?.currentContext != null) {
        Scrollable.ensureVisible(key!.currentContext!, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
  }

  void _scrollToLatestAdded() {
    final latestAdded = ref.watch(fibonacciProvider).latestAddedFibonacci;
    if (latestAdded != null && _mainListItemKeys.containsKey(latestAdded.index)) {
      final key = _mainListItemKeys[latestAdded.index];

      if (key?.currentContext != null) {
        Scrollable.ensureVisible(key!.currentContext!, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final removedItems = ref.watch(fibonacciProvider).removedFibonacci;
        final latestRemoved = ref.watch(fibonacciProvider).latestRemovedFibonacci;
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            controller: _scrollControllerForBottomSheet,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: List.generate(
                removedItems
                    .where((item) => getSymbolType(item.number) == getSymbolType(latestRemoved?.number ?? 0))
                    .toList()
                    .length,
                (index) {
                  FibonacciModel item =
                      removedItems
                          .where((item) => getSymbolType(item.number) == getSymbolType(latestRemoved?.number ?? 0))
                          .toList()[index];
                  _bottomSheetListItemKeys[item.index] = GlobalKey();
                  bool isLatestRemoved = item == latestRemoved;
                  return GestureDetector(
                    onTap: () {
                      fibonacciNotifier.onTapAddNumber(index: index, selectedItemType: getSymbolType(item.number));
                      Navigator.of(context).pop();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToLatestAdded();
                      });
                    },
                    child: Container(
                      key: _bottomSheetListItemKeys[item.index],
                      padding: EdgeInsets.symmetric(vertical: kMargin8, horizontal: kMargin16),
                      color: isLatestRemoved ? Colors.green : Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Number : ${item.number}", style: TextStyle(fontWeight: FontWeight.w500)),
                              Text("Index : ${item.index}", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Spacer(),
                          _getSymbolIcon(getSymbolType(item.number)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fibonacciNumbers = ref.watch(fibonacciProvider).fibonacciList;
    final latestAdded = ref.watch(fibonacciProvider).latestAddedFibonacci;

    return Scaffold(
      appBar: AppBar(title: Text("Fibonacci List"), centerTitle: true),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(fibonacciNumbers.length, (index) {
            final item = fibonacciNumbers[index];
            _mainListItemKeys[item.index] = GlobalKey();
            bool isLatestAdded = latestAdded == item;
            return GestureDetector(
              onTap: () {
                fibonacciNotifier.onTapRemoveNumber(index: index);
                _showBottomSheet(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToLatestRemoved();
                });
              },
              child: Container(
                key: _mainListItemKeys[item.index],
                color: (isLatestAdded) ? Colors.red : Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: kMargin16, vertical: kMargin18),
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Index : ${item.index}, Number : ${item.number}"),
                    Spacer(),
                    _getSymbolIcon(getSymbolType(item.number)),
                  ],
                ),
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
