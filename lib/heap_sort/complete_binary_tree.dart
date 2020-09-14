import 'dart:math' as math;

import 'package:algo_view/heap_sort/fixed_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CompleteBinaryTree extends StatefulWidget {
  final List<int> initialItems;

  CompleteBinaryTree({this.initialItems});

  @override
  _CompleteBinaryTreeState createState() => _CompleteBinaryTreeState();
}

class _CompleteBinaryTreeState extends State<CompleteBinaryTree> {
  //how many nodes in the tree
  int treeSize;

  List<int> treeItems;

  List<Offset> nodesCenters;

  double nodeRadius;

  ///how many levels in the tree, starts from 0
  int levelsNumber;
  @override
  void initState() {
    super.initState();
  }

  //method that calc log2(x)
  int log2(int x) => (math.log(x) / math.ln2).ceil();

  ///
  //the size of a specific level
  int levelSizeCalc(int levelNumber) => math.pow(2, levelNumber).toInt();

  ///tree size (i.e nodes number) until a specific level
  ///it represents the sum of the levels sizes from level 0 to
  ///the given level
  int treeSizeUntilLeve(int levelNumber) {
    int size = 0;
    for (int i = 0; i <= levelNumber; i++) {
      size += levelSizeCalc(i);
    }
    return size;
  }

  ///
  ///full complete tree is a tree where every nodes but leaves
  ///has exactly two childs and it's diffrenet from the tree size
  ///which refere to the acutal number of nodes in the tree.
  ///so the size of such a full tree is given by
  ///   2^0    +       2^1     + ..... + 2^levelsNumber
  ///level 0 size, level 1 size, .....,  level n size
  ///and this is a popular series which has simple formula.
  int get fullTreeSize =>
      (((1 - math.pow(2, levelsNumber + 1)) / (1 - 2))).floor();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print(constraints.maxHeight);
      treeItems = widget.initialItems;
      treeSize = treeItems.length;
      levelsNumber = log2(treeSize) - 1;

      ///how many nodes in the last level
      int lastLevelSize = levelSizeCalc(levelsNumber);

      ///distance between two nodes in the last level(i.e between to brothers)
      int lastLevelTwoNodesDistance = 10;

      ///distance between two pairs of nodes in the last level
      ///i.e(between cousins)
      int lastLevelTwoPairsDistance = 2 * lastLevelTwoNodesDistance;

      ///half last level size will decide how many times we will put
      ///distance betwee two nodes or two paires
      int halfLastLevelSize = (lastLevelSize / 2).floor();

      ///how many times we will put distance between two nodes
      int twoNodesDistanceNumber = halfLastLevelSize;

      ///how many times we will put distance betwwen two paires
      int twoPairsDistanceNumber = halfLastLevelSize - 1;

      ///calculating the radius:
      ///we take the whole width, subtruct from it all distances between
      ///two nodes and two paires, then divide by last level size.
      ///thus far we got the node diameter, inorder to get the radius
      ///we divide by two
      nodeRadius = ((constraints.maxWidth -
                  (twoNodesDistanceNumber * lastLevelTwoNodesDistance) -
                  (lastLevelTwoPairsDistance * twoPairsDistanceNumber)) /
              lastLevelSize) /
          2;

      ///list to holdes the center coordinates for every node
      nodesCenters = List(fullTreeSize);

      ///last node center
      nodesCenters[nodesCenters.length - 1] = Offset(
        constraints.maxWidth.floor().toDouble() - nodeRadius, //dx
        constraints.maxHeight.floor().toDouble() - nodeRadius, //dy
      );

      ///itrator to track last origin that is filled
      int nodesCentersItrator = nodesCenters.length - 1;

      ///calculate the center of the rest nodes at last level
      {
        Offset lastNodeOrigin = nodesCenters.last;
        double dy = lastNodeOrigin.dy;
        int x = lastLevelTwoNodesDistance;
        int xAxisChangesTodistance = 0;
        for (int i = 1; i <= lastLevelSize - 1; i++) {
          xAxisChangesTodistance += i.isOdd ? x : 2 * x;
          double dx =
              lastNodeOrigin.dx - (xAxisChangesTodistance + i * 2 * nodeRadius);
          nodesCenters[--nodesCentersItrator] = Offset(dx, dy);
        }
      }

      //calculate the centers for the rest nodes/
      {
        print(nodesCentersItrator);
        var levelNumber = levelsNumber - 1;
        var levelSize = levelSizeCalc(levelNumber);
        print(levelNumber);
        double dy = nodesCenters[nodesCentersItrator].dy - 50;
        for (int i = 1; i <= levelSize && levelNumber > -1; i++) {
          int parentIndex = --nodesCentersItrator;
          int leftChild = 2 * parentIndex + 1;
          int rightChild = 2 * parentIndex + 2;
          var dx =
              (nodesCenters[leftChild].dx + nodesCenters[rightChild].dx) / 2;
          nodesCenters[parentIndex] = Offset(dx, dy);
          if (i == levelSize) {
            print('hello');
            levelNumber--;
            levelSize = levelSizeCalc(levelNumber);
            dy -= 75;
            i = 0;
          }
        }
      }
      print(nodesCenters);
      return Stack(
        children: <Widget>[
          Container(
            color: Colors.blue,
          ),
          Transform.translate(
            offset: Offset(constraints.maxWidth.floor().toDouble() - nodeRadius,
                constraints.maxHeight.floor().toDouble() - nodeRadius),
            child: Container(
              height: 1,
              width: 1,
              color: Colors.black,
            ),
          ),
          ...treeItems.map((i) {
            if (i == null)
              return Container();
            else
              return FixedCircle(
                center: nodesCenters[nodesCentersItrator++],
                radius: nodeRadius,
              );
          }).toList()
        ],
      );
    });
  }
}
