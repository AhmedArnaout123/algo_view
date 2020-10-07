import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:algo_view/heap_sort/widgets/comparing_indicator.dart';
import 'package:algo_view/heap_sort/widgets/fixed_circle.dart';
import 'package:algo_view/heap_sort/widgets/line.dart';
import 'package:algo_view/heap_sort/widgets/sorting_widget.dart';

class CompleteBinaryTree extends StatelessWidget {
  final List<int> items;
  final Duration swipingAnimationDuration;
  final Duration comparingIndicatorDuration;

  CompleteBinaryTree({
    this.items,
    this.swipingAnimationDuration,
    this.comparingIndicatorDuration,
  });

  //method that calc log2(x)
  int log2(int x) {
    double val = (math.log(x) / math.ln2);
    if (val.ceil() == val.floor()) {
      return val.toInt() + 1;
    }
    return val.ceil();
  }

  //the capacity of a specific level
  int levelCapacityCalculator(int levelNumber) =>
      math.pow(2, levelNumber).toInt();

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

  ///full complete tree is a tree where every nodes but leaves
  ///has exactly two childs and it's diffrenet from the tree size
  ///which refere to the acutal number of nodes in the tree.
  ///so the size of such a full tree is given by
  ///   2^0    +       2^1     + ..... + 2^treeLevels
  ///level 0 size, level 1 size, .....,  level n size
  ///and this is a popular series which has simple formula.
  int fullTreeSize(int treeLevels) =>
      (((1 - math.pow(2, treeLevels + 1)) / (1 - 2))).floor();

  @override
  Widget build(BuildContext context) {
    //
    UISortingDataProvider uiSortingDataProvider =
        InheritedSortingWidget.of(context).uiSortingDataProvider;

    int treeSize = uiSortingDataProvider.size;

    ///how many levels in the tree, starts from 0
    int treeLevels = log2(treeSize) - 1;

    ///list to holdes the center coordinates for every node
    List<Offset> nodesCenters = List(fullTreeSize(treeLevels));

    double nodeRadius;

    return LayoutBuilder(
      builder: (context, constraints) {
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
            ...uiSortingDataProvider.items
                .asMap()
                .map((index, item) {
                  return MapEntry(
                    index,
                    FixedCircle(
                      center: nodesCenters[index],
                      radius: nodeRadius,
                      border: Border.all(width: 1),
                      child: Center(
                        child: FittedBox(
                          child: Transform.translate(
                            offset: uiSortingDataProvider
                                .itemsWidgetsOffsets[index],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.8),
                              child: Text(uiSortingDataProvider.items[index]
                                  .toString()),
                            ),
                          ),
                          key: uiSortingDataProvider
                              .itemsWidgetsGlobalKeys[index],
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
                            Positioned(
                              left: maxWidth / 2,
                              child: 2 * key + 1 < treeSize
                                  ? Line(
                                      color: Colors.black,
                                      start: Offset(
                                          value.dx, value.dy + nodeRadius),
                                      end: Offset(
                                        nodesCenters[2 * key + 2].dx,
                                        nodesCenters[2 * key + 2].dy -
                                            nodeRadius,
                                      ),
                                    )
                                  : Container(),
                            ),
                            Positioned(
                              left: maxWidth / 2,
                              child: 2 * key + 2 < treeSize
                                  ? Line(
                                      color: Colors.black,
                                      start: Offset(
                                          value.dx, value.dy + nodeRadius),
                                      end: Offset(
                                        nodesCenters[2 * key + 1].dx,
                                        nodesCenters[2 * key + 1].dy -
                                            nodeRadius,
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
            ...uiSortingDataProvider.haveItemsComparingIndicators
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
                                animationDuration: comparingIndicatorDuration,
                              ),
                            )
                          : Container());
                })
                .values
                .toList(),
          ],
        );
      },
    );
  }
}
