import 'dart:math' as math;

import 'package:algo_view/heap_sort/comparing_indicator.dart';
import 'package:algo_view/heap_sort/fixed_circle.dart';
import 'package:algo_view/heap_sort/line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnTreeCreated = void Function(CompleteBinaryTreeController);

class CompleteBinaryTree extends StatefulWidget {
  final List<int> items;
  final OnTreeCreated onTreeCreated;
  final Duration swipingAnimationDuration;
  final Duration comparingIndicatorDuration;

  CompleteBinaryTree({
    this.items,
    this.onTreeCreated,
    this.swipingAnimationDuration,
    this.comparingIndicatorDuration,
  });

  @override
  _CompleteBinaryTreeState createState() => _CompleteBinaryTreeState();
}

class _CompleteBinaryTreeState extends State<CompleteBinaryTree>
    with SingleTickerProviderStateMixin {
  //how many nodes in the tree
  int treeSize;

  List<int> treeItems;

  ///list to holdes the center coordinates for every node
  List<Offset> nodesCenters;

  double nodeRadius;

  List<GlobalKey> nodesTextGlobalKeys;

  List<Offset> nodesTextOffset;

  List<double> nodesOpacity;

  int nodesOpacityTracker;

  List<bool> nodesComapringIndicators;

  ///how many levels in the tree, starts from 0
  int treeLevels;

  AnimationController _animationController;
  Duration _animationDuration;

  CompleteBinaryTreeController treeController;

  //method that calc log2(x)
  int log2(int x) {
    double val = (math.log(x) / math.ln2);
    if (val.ceil() == val.floor()) {
      return val.toInt() + 1;
    }
    return val.ceil();
  }

  ///
  //the capacity of a specific level
  int levelCapacityCalculator(int levelNumber) =>
      math.pow(2, levelNumber).toInt();

  int get lastLevelSize => treeSize - treeSizeUntilLeve(treeLevels - 1);

  ///tree size (i.e nodes number) until a specific level
  ///it represents the sum of the levels sizes from level 0 to
  ///the given level
  int treeSizeUntilLeve(int levelNumber) {
    int size = 0;
    for (int i = 0; i <= levelNumber; i++) {
      size += levelCapacityCalculator(i);
    }
    return size;
  }

  ///
  ///full complete tree is a tree where every nodes but leaves
  ///has exactly two childs and it's diffrenet from the tree size
  ///which refere to the acutal number of nodes in the tree.
  ///so the size of such a full tree is given by
  ///   2^0    +       2^1     + ..... + 2^treeLevels
  ///level 0 size, level 1 size, .....,  level n size
  ///and this is a popular series which has simple formula.
  int get fullTreeSize =>
      (((1 - math.pow(2, treeLevels + 1)) / (1 - 2))).floor();

  void swipeItems(int i1, i2) {
    var t = treeItems[i1];
    treeItems[i1] = treeItems[i2];
    treeItems[i2] = t;
  }

  void initializeTreeProperties() {
    treeItems = List.from(widget.items);
    treeSize = treeItems.length;
    treeLevels = log2(treeSize) - 1;
    nodesCenters = List(fullTreeSize);
    nodesTextGlobalKeys = List.generate(treeSize, (_) => GlobalKey());
    nodesTextOffset = List.generate(treeSize, (_) => Offset.zero);
    nodesOpacity = List.generate(treeSize, (_) => 1);
    nodesOpacityTracker = nodesOpacity.length - 1;
    nodesComapringIndicators = List.generate(treeSize, (_) => false);
  }

  @override
  void initState() {
    super.initState();
    initializeTreeProperties();
    _animationDuration = widget.swipingAnimationDuration;
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    treeController = CompleteBinaryTreeController(this);
    widget.onTreeCreated(treeController);
  }

  @override
  void didUpdateWidget(CompleteBinaryTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    initializeTreeProperties();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      ///how many nodes in the last level
      int lastLevelCapacity = levelCapacityCalculator(treeLevels);

      ///distance between two nodes in the last level(i.e between to brothers)
      int lastLevelTwoNodesDistance = 10;

      ///distance between two pairs of nodes in the last level
      ///i.e(between cousins)
      int lastLevelTwoPairsDistance = 2 * lastLevelTwoNodesDistance;

      ///half last level size will decide how many times we will put
      ///distance betwee two nodes or two paires
      int halflastLevelCapacity = (lastLevelCapacity / 2).floor();

      ///how many times we will put distance between two nodes
      int twoNodesDistanceNumber = halflastLevelCapacity;

      ///how many times we will put distance betwwen two paires
      int twoPairsDistanceNumber = halflastLevelCapacity - 1;

      ///calculating the radius:
      ///we take the whole width, subtruct from it all distances between
      ///two nodes and two paires, then divide by last level size.
      ///thus far we got the node diameter, inorder to get the radius
      ///we divide by two
      nodeRadius = ((constraints.maxWidth -
                  (twoNodesDistanceNumber * lastLevelTwoNodesDistance) -
                  (lastLevelTwoPairsDistance * twoPairsDistanceNumber)) /
              lastLevelCapacity) /
          2;

      ///last node center
      nodesCenters[nodesCenters.length - 1] = Offset(
        constraints.maxWidth.floor().toDouble() - nodeRadius, //dx
        constraints.maxHeight.floor().toDouble() - nodeRadius, //dy
      );

      ///itrator to track last origin that is filled
      int nodesCentersItrator = nodesCenters.length - 1;

      ///calculate the center of the rest nodes at last level
      {
        Offset lastNodeCenter = nodesCenters.last;
        double dy = lastNodeCenter.dy;
        int x = lastLevelTwoNodesDistance;
        int xAxisShift = 0;
        for (int i = 1; i <= lastLevelCapacity - 1; i++) {
          xAxisShift += i.isOdd ? x : 2 * x;
          double dx = lastNodeCenter.dx - (xAxisShift + i * 2 * nodeRadius);
          nodesCenters[--nodesCentersItrator] = Offset(dx, dy);
        }
      }

      //calculate the centers for the rest nodes/
      {
        double heightBetweenTwoLevels =
            (constraints.maxHeight - 2 * nodeRadius) / treeLevels;
        var levelNumber = treeLevels - 1;
        var levelSize = levelCapacityCalculator(levelNumber);
        double dy =
            nodesCenters[nodesCentersItrator].dy - heightBetweenTwoLevels;
        for (int i = 1; i <= levelSize && levelNumber > -1; i++) {
          int parentIndex = --nodesCentersItrator;
          int leftChild = 2 * parentIndex + 1;
          int rightChild = 2 * parentIndex + 2;
          var dx =
              (nodesCenters[leftChild].dx + nodesCenters[rightChild].dx) / 2;
          nodesCenters[parentIndex] = Offset(dx, dy);
          if (i == levelSize) {
            levelNumber--;
            levelSize = levelCapacityCalculator(levelNumber);
            dy -= heightBetweenTwoLevels;
            i = 0;
          }
        }
      }

      return Stack(
        children: <Widget>[
          // Container(
          //   color: Colors.blue,
          // ),
          ...treeItems
              .asMap()
              .map((index, item) {
                return MapEntry(
                  index,
                  Opacity(
                    opacity: nodesOpacity[index],
                    child: FixedCircle(
                      center: nodesCenters[index],
                      radius: nodeRadius,
                      border: Border.all(width: 1),
                      child: Center(
                        child: FittedBox(
                          child: Transform.translate(
                            offset: nodesTextOffset[index],
                            child: Text(treeItems[index].toString()),
                          ),
                          key: nodesTextGlobalKeys[index],
                        ),
                      ),
                    ),
                  ),
                );
              })
              .values
              .toList(),
          ...nodesCenters
              .asMap()
              .map<int, Widget>((key, value) {
                if (key >= levelCapacityCalculator(treeLevels) - 1) {
                  return MapEntry(key, Container());
                }
                var maxHeight = nodesCenters[2 * key + 1].dy - value.dy;
                var maxWidth = (nodesCenters[2 * key + 2].dx + nodeRadius) -
                    (nodesCenters[2 * key + 1].dx - nodeRadius);
                return MapEntry(
                  key,
                  Positioned(
                    left: nodesCenters[key * 2 + 1].dx - nodeRadius,
                    top: value.dy + nodeRadius,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: maxHeight,
                        maxWidth: maxWidth,
                      ),
                      child: Stack(
                        children: [
                          // Container(
                          //   color: Colors.orange.withOpacity(0.2),
                          // ),
                          Positioned(
                            left: maxWidth / 2,
                            child: 2 * key + 1 < treeSize &&
                                    nodesOpacity[2 * key + 1] == 1
                                ? Line(
                                    color: Colors.black,
                                    start:
                                        Offset(value.dx, value.dy + nodeRadius),
                                    end: Offset(
                                      nodesCenters[2 * key + 2].dx,
                                      nodesCenters[2 * key + 2].dy - nodeRadius,
                                    ),
                                  )
                                : Container(),
                          ),
                          Positioned(
                            left: maxWidth / 2,
                            child: 2 * key + 2 < treeSize &&
                                    nodesOpacity[2 * key + 2] == 1
                                ? Line(
                                    color: Colors.black,
                                    start:
                                        Offset(value.dx, value.dy + nodeRadius),
                                    end: Offset(
                                      nodesCenters[2 * key + 1].dx,
                                      nodesCenters[2 * key + 1].dy - nodeRadius,
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
              .values
              .toList(),
          ...nodesComapringIndicators
              .asMap()
              .map((key, value) {
                return MapEntry(
                    key,
                    value
                        ? FixedCircle(
                            center: nodesCenters[key],
                            radius: nodeRadius + 3,
                            child: ComparingIndicator(
                              height: 2 * nodeRadius,
                              borderWidth: 3,
                              shape: ComparingIndicatorShape.Circle,
                              animationDuration:
                                  widget.comparingIndicatorDuration,
                            ),
                          )
                        : Container());
              })
              .values
              .toList()
        ],
      );
    });
  }
}

class CompleteBinaryTreeController {
  _CompleteBinaryTreeState _state;
  CompleteBinaryTreeController(this._state);
  Future<void> swipeItems(int index1, int index2) async {
    RenderBox child1Box =
        _state.nodesTextGlobalKeys[index1].currentContext.findRenderObject();
    var child1Offset = child1Box.localToGlobal(Offset.zero);
    RenderBox child2Box =
        _state.nodesTextGlobalKeys[index2].currentContext.findRenderObject();
    var child2Offset = child2Box.localToGlobal(Offset.zero);
    Animation<Offset> animation =
        Tween<Offset>(begin: child1Offset, end: child2Offset)
            .animate(_state._animationController);
    void listner() {
      child1Box =
          _state.nodesTextGlobalKeys[index1].currentContext.findRenderObject();
      child2Box =
          _state.nodesTextGlobalKeys[index2].currentContext.findRenderObject();
      var dx = animation.value.dx - child1Offset.dx;
      var dy = animation.value.dy - child1Offset.dy;
      child1Offset = animation.value;
      child2Offset = child2Offset - Offset(dx, dy);
      _state.setState(() {
        _state.nodesTextOffset[index1] = child1Box.globalToLocal(child1Offset);
        _state.nodesTextOffset[index2] = child2Box.globalToLocal(child2Offset);
      });
    }

    _state._animationController.addListener(listner);

    await _state._animationController.forward();

    _state.setState(() {
      _state.swipeItems(index1, index2);
      _state.nodesTextOffset[index1] = Offset.zero;
      _state.nodesTextOffset[index2] = Offset.zero;
    });

    _state._animationController.removeListener(listner);

    _state._animationController.reset();
  }

  void hideLastNode() {
    if (_state.nodesOpacityTracker < 0) {
      return;
    }
    _state.setState(() {
      _state.nodesOpacity[_state.nodesOpacityTracker--] = 0;
    });
  }

  void showComparingIndicators(int index1, int index2) {
    _state.setState(() {
      _state.nodesComapringIndicators[index1] = true;
      _state.nodesComapringIndicators[index2] = true;
    });
  }

  void hideComparingIndicators(int index1, int index2) {
    _state.setState(() {
      _state.nodesComapringIndicators[index1] = false;
      _state.nodesComapringIndicators[index2] = false;
    });
  }
}
