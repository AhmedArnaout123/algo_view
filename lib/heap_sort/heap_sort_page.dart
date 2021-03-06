import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:algo_view/heap_sort/bloc/sorting_bloc.dart';
import 'package:algo_view/heap_sort/widgets/size_picker.dart';
import 'package:algo_view/heap_sort/widgets/sorting_widget.dart';

enum ComparingIndicatorAction { Show, Hide }

class HeapSortPage extends StatefulWidget {
  @override
  _HeapSortPageState createState() => _HeapSortPageState();
}

class _HeapSortPageState extends State<HeapSortPage>
    with SingleTickerProviderStateMixin {
  int treeSize = 8;
  List<int> items;

  Duration comparingIndicatorDuration = Duration(milliseconds: 400);
  Duration swipingDuration = Duration(milliseconds: 300);
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    randomizeItems();
  }

  void randomizeItems() {
    items = List.generate(treeSize, (index) => math.Random().nextInt(999));
  }

  void swap(List<int> arr, int i, int j) {
    // arrayController.swapItems(i, j);
    // treeController.swapItems(i, j);
    BlocProvider.of<SortingBloc>(context).add(
      SwapedItemsSortingEvent(index1: i, index2: j),
    );
    int t = arr[i];
    arr[i] = arr[j];
    arr[j] = t;
  }

  void changeComparingIndicatorStatus(
    ComparingIndicatorAction action,
    int i,
    int j,
  ) {
    if (action == ComparingIndicatorAction.Hide) {
      // arrayController.hideComparingIndicators(i, j);
      // treeController.hideComparingIndicators(i, j);
      BlocProvider.of<SortingBloc>(context).add(
        ComparedItemsSortingEvent(
          index1: i,
          index2: j,
          type: ComparedItemsEventType.HideComparingIndicator,
        ),
      );
      return;
    }
    // arrayController.showComparingIndicators(i, j);
    // treeController.showComparingIndicators(i, j);
    BlocProvider.of<SortingBloc>(context).add(
      ComparedItemsSortingEvent(
        index1: i,
        index2: j,
        type: ComparedItemsEventType.ShowComparingIndicator,
      ),
    );
  }

  Future<void> heapSort(List<int> arr, int start, int end) async {
    await buildHeapForTree(arr, start, end);
    for (int i = end; i > start; i--) {
      swap(arr, start, i);
      await Future.delayed(
          Duration(milliseconds: swipingDuration.inMilliseconds + 100));
      await buildHeapAtNode(arr, start, i - 1);
    }
  }

  Future<void> buildHeapForTree(List<int> arr, int start, int end) async {
    //find last parent in the tree
    int lastParent = end.isEven ? (end - 2) ~/ 2 : (end - 1) ~/ 2;
    for (int i = lastParent; i >= start; i--) {
      await buildHeapAtNode(arr, i, end);
    }
    print('done building $arr');
  }

  Future<void> buildHeapAtNode(List<int> arr, int nodeIndex, int end) async {
    //left child index
    int left = 2 * nodeIndex + 1;
    //if the node has left child we keep going otherwise we return
    if (left <= end) {
      //assume the left child is the larger child so let's keep eye on it's index
      int largerIndex = left;
      //right child index
      int right = 2 * nodeIndex + 2;
      //if the right child is exist and it's larger than the left one
      //change the larger index
      if (right <= end) {
        changeComparingIndicatorStatus(
          ComparingIndicatorAction.Show,
          right,
          left,
        );
        await Future.delayed(comparingIndicatorDuration);
        changeComparingIndicatorStatus(
          ComparingIndicatorAction.Hide,
          right,
          left,
        );
        if (arr[largerIndex] < arr[right]) {
          largerIndex = right;
        }
      }
      changeComparingIndicatorStatus(
        ComparingIndicatorAction.Show,
        nodeIndex,
        largerIndex,
      );
      await Future.delayed(comparingIndicatorDuration);
      changeComparingIndicatorStatus(
        ComparingIndicatorAction.Hide,
        nodeIndex,
        largerIndex,
      );
      //compare parent with it's larger child
      if (arr[nodeIndex] < arr[largerIndex]) {
        //the child is larger than  it's parent so we need to swap then
        //rebuild the heap for the parent in it's new index
        swap(arr, nodeIndex, largerIndex);
        await Future.delayed(
            Duration(milliseconds: swipingDuration.inMilliseconds + 100));
        await buildHeapAtNode(arr, largerIndex, end);
      }
      //the parent is larger than it's larger child so nothing to do
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.red.withOpacity(0.2),
          child: ListView(
            padding: EdgeInsets.all(8),
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizePicker(
                      value: treeSize,
                      onChanged: isRunning
                          ? null
                          : (value) {
                              setState(() {
                                treeSize = value;
                                randomizeItems();
                              });
                            },
                    ),
                    Expanded(
                      child: _ButtonsBar(
                        sortingCallBack: isRunning
                            ? null
                            : () async {
                                setState(() {
                                  isRunning = true;
                                });
                                await heapSort(items, 0, items.length - 1);
                                setState(() {
                                  isRunning = false;
                                });
                              },
                        randomizationCallBack: isRunning
                            ? null
                            : () {
                                setState(() {
                                  randomizeItems();
                                });
                              },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: SortingWidget(
                  items: items,
                  layout: SortingWidgetLayout.tree,
                  comparingIndicatorDuration: comparingIndicatorDuration,
                  swapingDuration: swipingDuration,
                ),
              ),
              SizedBox(height: 20),
              SortingWidget(
                layout: SortingWidgetLayout.array,
                items: items,
                swapingDuration: swipingDuration,
                comparingIndicatorDuration: comparingIndicatorDuration,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonsBar extends StatelessWidget {
  final void Function() sortingCallBack;
  final void Function() randomizationCallBack;

  const _ButtonsBar({Key key, this.sortingCallBack, this.randomizationCallBack})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(
          flex: 1,
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: RaisedButton(
              color: Colors.yellow,
              child: FittedBox(child: Text('Heap Sort')),
              onPressed: sortingCallBack),
        ),
        Spacer(
          flex: 1,
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: RaisedButton(
            color: Colors.yellow,
            child: Icon(Icons.shuffle),
            onPressed: randomizationCallBack,
          ),
        ),
      ],
    );
  }
}
