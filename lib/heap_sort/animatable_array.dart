import 'package:algo_view/heap_sort/comparing_indicator.dart';
import 'package:algo_view/heap_sort/sorting_widget.dart';
import 'package:flutter/material.dart';

import 'bloc/sorting_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// typedef OnArrayCreated = void Function(AnimatableArrayController);

class AnimatableArray extends StatefulWidget {
  final List<int> items;
  final Duration swipingDuration;
  final Duration comparingIndicatorDuration;
  // final OnArrayCreated onArrayCreated;

  const AnimatableArray({
    Key key,
    this.items,
    this.swipingDuration,
    // this.onArrayCreated,
    this.comparingIndicatorDuration,
  }) : super(key: key);
  @override
  _AnimatableArrayState createState() => _AnimatableArrayState();
}

class _AnimatableArrayState extends State<AnimatableArray>
    with SingleTickerProviderStateMixin {
  // List<int> items;
  // int size;

  // List<GlobalKey> nodesTextGlobalKeys;

  // List<Offset> nodesTextOffset;

  // AnimationController _animationController;
  // AnimatableArrayController controller;
  // List<bool> comparingIndicators;

  // void swipeItems(int i1, i2) {
  //   var t = items[i1];
  //   items[i1] = items[i2];
  //   items[i2] = t;
  // }

  // void initializeAraayProperties() {
  //   items = List.from(widget.items);
  //   size = items.length;
  //   nodesTextGlobalKeys = List.generate(size, (_) => GlobalKey());
  //   nodesTextOffset = List.generate(size, (_) => Offset.zero);
  //   widget.onArrayCreated(controller);
  //   comparingIndicators = List.generate(size, (_) => false);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   controller = AnimatableArrayController(this);
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: widget.swipingDuration,
  //   );
  //   initializeAraayProperties();
  // }

  // @override
  // void didUpdateWidget(oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   initializeAraayProperties();
  // }

  @override
  Widget build(BuildContext context) {
    UISortingDataProvider sortingDataProvider =
        InheritedSortingWidget.of(context).uiSortingDataProvider;
    return Container(
      height: 150,
      // color: Colors.red.withOpacity(0.2),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 0,
        children: [
          ...sortingDataProvider.items
              .asMap()
              .map((k, v) => MapEntry(
                    k,
                    Flex(
                      direction: Axis.vertical,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: Text('${k.toString()}'),
                        ),
                        Container(
                          width: 50,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Transform.translate(
                                  offset: sortingDataProvider
                                      .itemsWidgetsOffsets[k],
                                  child: Text(
                                    sortingDataProvider.items[k].toString(),
                                    key: sortingDataProvider
                                        .itemsWidgetsGlobalKeys[k],
                                  ),
                                ),
                              ),
                              if (sortingDataProvider
                                  .haveItemsComparingIndicators[k])
                                LayoutBuilder(
                                  builder: (_, c) => ComparingIndicator(
                                    borderWidth: 2,
                                    height: c.maxHeight,
                                    width: c.maxWidth,
                                    shape: ComparingIndicatorShape.Rectangle,
                                    animationDuration:
                                        widget.comparingIndicatorDuration,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
              .values
        ],
      ),
    );
  }
}

// class AnimatableArrayController {
//   final _AnimatableArrayState _state;
//   AnimatableArrayController(this._state);
//   Future<void> swipeItems(int index1, int index2) async {
//     RenderBox child1Box =
//         _state.nodesTextGlobalKeys[index1].currentContext.findRenderObject();
//     var child1Offset = child1Box.localToGlobal(Offset.zero);
//     RenderBox child2Box =
//         _state.nodesTextGlobalKeys[index2].currentContext.findRenderObject();
//     var child2Offset = child2Box.localToGlobal(Offset.zero);

//     double xDistance = child1Offset.dx - child2Offset.dx;
//     double yDistance = child1Offset.dy - child2Offset.dy;

//     double child1TotalDx = -xDistance;
//     double child2TotalDx = -child1TotalDx;

//     double child1TotalDy = -yDistance;
//     double child2TotalDy = -child1TotalDy;

//     Offset newChild1Offset = Offset(child1TotalDx, child1TotalDy);
//     Offset newChild2Offset = Offset(child2TotalDx, child2TotalDy);

//     Animation<Offset> index1Animation =
//         Tween<Offset>(begin: Offset.zero, end: newChild1Offset)
//             .animate(_state._animationController);
//     Animation<Offset> index2Animation =
//         Tween<Offset>(begin: Offset.zero, end: newChild2Offset)
//             .animate(_state._animationController);
//     void listner() {
//       _state.setState(() {
//         _state.nodesTextOffset[index1] = index1Animation.value;
//         _state.nodesTextOffset[index2] = index2Animation.value;
//       });
//     }

//     _state._animationController.addListener(listner);

//     await _state._animationController.forward();
//     _state._animationController.removeListener(listner);
//     _state.setState(() {
//       _state.swipeItems(index1, index2);
//       _state.nodesTextOffset[index1] = Offset.zero;
//       _state.nodesTextOffset[index2] = Offset.zero;
//     });
//     _state._animationController.reset();
//   }

//   void showComparingIndicators(int index1, int index2) {
//     _state.setState(() {
//       _state.comparingIndicators[index1] = true;
//       _state.comparingIndicators[index2] = true;
//     });
//   }

//   void hideComparingIndicators(int index1, int index2) {
//     _state.setState(() {
//       _state.comparingIndicators[index1] = false;
//       _state.comparingIndicators[index2] = false;
//     });
//   }
// }
