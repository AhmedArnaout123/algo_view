import 'package:algo_view/heap_sort/widgets/animatable_array.dart';
import 'package:algo_view/heap_sort/widgets/complete_binary_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/sorting_bloc.dart';

enum SortingWidgetLayout { tree, array }

class InheritedSortingWidget extends InheritedWidget {
  final UISortingDataProvider uiSortingDataProvider;
  // final Widget child;

  InheritedSortingWidget({
    @required this.uiSortingDataProvider,
    @required child,
  }) : super(child: child);

  static InheritedSortingWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedSortingWidget>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class SortingWidget extends StatefulWidget {
  final SortingWidgetLayout layout;
  final List<int> items;
  final Duration swapingDuration;
  final Duration comparingIndicatorDuration;

  const SortingWidget({
    Key key,
    @required this.layout,
    this.items,
    this.swapingDuration,
    this.comparingIndicatorDuration,
  }) : super(key: key);

  @override
  _SortingWidgetState createState() => _SortingWidgetState();
}

class _SortingWidgetState extends State<SortingWidget>
    with SingleTickerProviderStateMixin {
  //
  UISortingDataProvider uiSortingDataProvider;
  AnimationController _animationController;
  //
  Future<void> swapItems(int index1, int index2) async {
    RenderBox child1Box = uiSortingDataProvider
        .itemsWidgetsGlobalKeys[index1].currentContext
        .findRenderObject();
    var child1Offset = child1Box.localToGlobal(Offset.zero);
    RenderBox child2Box = uiSortingDataProvider
        .itemsWidgetsGlobalKeys[index2].currentContext
        .findRenderObject();
    var child2Offset = child2Box.localToGlobal(Offset.zero);

    double xDistance = child1Offset.dx - child2Offset.dx;
    double yDistance = child1Offset.dy - child2Offset.dy;

    double child1TotalDx = -xDistance;
    double child2TotalDx = -child1TotalDx;

    double child1TotalDy = -yDistance;
    double child2TotalDy = -child1TotalDy;

    Offset newChild1Offset = Offset(child1TotalDx, child1TotalDy);
    Offset newChild2Offset = Offset(child2TotalDx, child2TotalDy);

    Animation<Offset> index1Animation =
        Tween<Offset>(begin: Offset.zero, end: newChild1Offset)
            .animate(_animationController);
    Animation<Offset> index2Animation =
        Tween<Offset>(begin: Offset.zero, end: newChild2Offset)
            .animate(_animationController);
    void listner() {
      setState(() {
        uiSortingDataProvider.itemsWidgetsOffsets[index1] =
            index1Animation.value;
        uiSortingDataProvider.itemsWidgetsOffsets[index2] =
            index2Animation.value;
      });
    }

    _animationController.addListener(listner);

    await _animationController.forward();
    _animationController.removeListener(listner);
    setState(() {
      uiSortingDataProvider.swapItems(index1, index2);
      uiSortingDataProvider.itemsWidgetsOffsets[index1] = Offset.zero;
      uiSortingDataProvider.itemsWidgetsOffsets[index2] = Offset.zero;
    });
    _animationController.reset();
  }

  void showComparingIndicators(int index1, int index2) {
    setState(() {
      uiSortingDataProvider.haveItemsComparingIndicators[index1] = true;
      uiSortingDataProvider.haveItemsComparingIndicators[index2] = true;
    });
  }

  void hideComparingIndicators(int index1, int index2) {
    setState(() {
      uiSortingDataProvider.haveItemsComparingIndicators[index1] = false;
      uiSortingDataProvider.haveItemsComparingIndicators[index2] = false;
    });
  }

  @override
  void initState() {
    super.initState();
    uiSortingDataProvider = UISortingDataProvider(items: widget.items);
    _animationController =
        AnimationController(vsync: this, duration: widget.swapingDuration);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      uiSortingDataProvider = UISortingDataProvider(items: widget.items);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isArrayLayout = widget.layout == SortingWidgetLayout.array;
    return BlocListener<SortingBloc, SortingState>(
      listener: (context, state) {
        if (state is SwapingItemsSortingState) {
          swapItems(state.index1, state.index2);
          return;
        }
        if (state is ComparingItemsInProgressSortingState) {
          showComparingIndicators(state.index1, state.index2);
          return;
        }
        if (state is ComparingItemsIsDoneSortingState) {
          hideComparingIndicators(state.index1, state.index2);
        }
      },
      child: InheritedSortingWidget(
        uiSortingDataProvider: uiSortingDataProvider,
        child: isArrayLayout
            ? AnimatableArray(
                comparingIndicatorDuration: widget.comparingIndicatorDuration,
              )
            : CompleteBinaryTree(
                comparingIndicatorDuration: widget.comparingIndicatorDuration,
              ),
      ),
    );
  }
}

class UISortingDataProvider {
  List<int> items;
  List<Offset> itemsWidgetsOffsets;
  List<GlobalKey> itemsWidgetsGlobalKeys;
  List<bool> haveItemsComparingIndicators;

  UISortingDataProvider({@required List<int> items}) {
    initilizeData(items);
  }

  int get size => items.length;

  void initilizeData(List<int> items) {
    this.items = List.from(items);
    haveItemsComparingIndicators = List.generate(size, (index) => false);
    itemsWidgetsGlobalKeys = List.generate(size, (index) => GlobalKey());
    itemsWidgetsOffsets = List.generate(size, (index) => Offset(0, 0));
  }

  void swapItems(i, j) {
    int t = items[i];
    items[i] = items[j];
    items[j] = t;
  }
}
