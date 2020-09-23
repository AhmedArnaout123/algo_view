import 'package:algo_view/heap_sort/animatable_array.dart';
import 'package:algo_view/heap_sort/comparing_indicator.dart';
import 'package:algo_view/heap_sort/complete_binary_tree.dart';
import 'package:algo_view/heap_sort/heap_sort.dart';
import 'package:algo_view/heap_sort/line.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int treeSize = 8;
  List<int> items;
  CompleteBinaryTreeController treeController;
  AnimatableArrayController arrayController;
  Duration comparingIndicatorDuration = Duration(milliseconds: 400);
  Duration swipingDuration = Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    randomizeItems();
  }

  void randomizeItems() {
    items = List.generate(treeSize, (index) => math.Random().nextInt(999));
  }

  void swipe(List<int> arr, int i, int j) {
    int t = arr[i];
    arr[i] = arr[j];
    arr[j] = t;
  }

  Future<void> heapSort(List<int> arr, int start, int end) async {
    await buildHeapForTree(arr, start, end);
    for (int i = end; i > start; i--) {
      arrayController.swipeItems(i, start);
      treeController.swipeItems(i, start);
      await Future.delayed(
          Duration(milliseconds: swipingDuration.inMilliseconds + 100));
      swipe(arr, start, i);
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
        arrayController.showComparingIndicators(left, right);
        treeController.showComparingIndicators(left, right);
        await Future.delayed(comparingIndicatorDuration);
        arrayController.hideComparingIndicators(left, right);
        treeController.hideComparingIndicators(left, right);
        if (arr[largerIndex] < arr[right]) {
          largerIndex = right;
        }
      }
      arrayController.showComparingIndicators(nodeIndex, largerIndex);
      treeController.showComparingIndicators(nodeIndex, largerIndex);
      await Future.delayed(comparingIndicatorDuration);
      arrayController.hideComparingIndicators(nodeIndex, largerIndex);
      treeController.hideComparingIndicators(nodeIndex, largerIndex);
      //compare parent with it's larger child
      if (arr[nodeIndex] < arr[largerIndex]) {
        //the child is larger than  it's parent so we need to swipe then
        //rebuild the heap for the parent in it's new index
        arrayController.swipeItems(nodeIndex, largerIndex);
        treeController.swipeItems(nodeIndex, largerIndex);
        await Future.delayed(
            Duration(milliseconds: swipingDuration.inMilliseconds + 100));
        swipe(arr, nodeIndex, largerIndex);
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
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Color(0xff00003f),
              child: Row(
                children: [
                  Text(
                    'Size:',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton<int>(
                    value: treeSize,
                    onChanged: (_) {
                      setState(() {
                        treeSize = _;
                        randomizeItems();
                      });
                    },
                    items: List.generate(
                      14,
                      (index) => DropdownMenuItem(
                        value: index + 4,
                        child: Text((index + 4).toString(),
                            style: TextStyle(
                              color: Colors.blueAccent,
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        color: Colors.yellow,
                        child: Text('Randomize Items'),
                        onPressed: () {
                          setState(() {
                            randomizeItems();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10)
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 10),
              height: 300,
              child: CompleteBinaryTree(
                items: items,
                onTreeCreated: (c) {
                  treeController = c;
                },
                comparingIndicatorDuration: comparingIndicatorDuration,
                swipingAnimationDuration: swipingDuration,
              ),
            ),
            AnimatableArray(
              items: items,
              onArrayCreated: (c) {
                arrayController = c;
              },
              comparingIndicatorDuration: comparingIndicatorDuration,
              swipingDuration: swipingDuration,
            ),
            RaisedButton(
              onPressed: () async {
                // int index1 = math.Random().nextInt(treeSize);
                // int index2 = math.Random().nextInt(treeSize);
                // treeController.showComparingIndicators(index1, index2);
                // arrayController.showComparingIndicators(index1, index2);
                // await Future.delayed(Duration(seconds: 2));
                // treeController.hideComparingIndicators(index1, index2);
                // arrayController.hideComparingIndicators(index1, index2);
                // treeController.swipeItems(index1, index2);
                // arrayController.swipeItems(index1, index2);
                // print(items);
                await heapSort(items, 0, items.length - 1);
                print("done sorting $items");
                // for (int i = 0; i < 2; i++) {
                //   arrayController.swipeItems(0, items.length - 1);
                //   treeController.swipeItems(0, items.length - 1);
                //   await Future.delayed(Duration(
                //       milliseconds: swipingDuration.inMilliseconds + 100));
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
