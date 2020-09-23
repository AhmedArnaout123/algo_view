import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

typedef OnArrayCreated = void Function(AnimatableArrayController);

class AnimatableArray extends StatefulWidget {
  final List<int> items;
  final Duration animationDuration;
  final OnArrayCreated onArrayCreated;
  const AnimatableArray(
      {Key key, this.items, this.animationDuration, this.onArrayCreated})
      : super(key: key);
  @override
  _AnimatableArrayState createState() => _AnimatableArrayState();
}

class _AnimatableArrayState extends State<AnimatableArray>
    with SingleTickerProviderStateMixin {
  List<int> items;
  int size;

  List<GlobalKey> nodesTextGlobalKeys;

  List<Offset> nodesTextOffset;

  AnimationController _animationController;
  List<Animation<Offset>> _animation;
  AnimatableArrayController controller;
  List<double> dxOffsets;
  List<double> dyOffsets;

  void swipeItems(int i1, i2) {
    var t = items[i1];
    items[i1] = items[i2];
    items[i2] = t;
  }

  void initializeAraayProperties() {
    items = List.from(widget.items);
    size = items.length;
    nodesTextGlobalKeys = List.generate(size, (_) => GlobalKey());
    nodesTextOffset = List.generate(size, (_) => Offset.zero);
    widget.onArrayCreated(controller);
    _animation = List.generate(
      size,
      (_) => Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
        _animationController,
      ),
    );
    dxOffsets = List.generate(size, (_) => 0);
    dyOffsets = List.generate(size, (_) => 0);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimatableArrayController(this);
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    initializeAraayProperties();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    initializeAraayProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.red.withOpacity(0.2),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 0,
        children: [
          ...items
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
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0, color: Colors.purple)),
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: Container(
                            width: 50,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              child: Transform(
                                transform: Matrix4.translation(
                                    Vector3(dxOffsets[k], dyOffsets[k], 0)),
                                child: Text(
                                  items[k].toString(),
                                  key: nodesTextGlobalKeys[k],
                                ),
                              ),
                            ),
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

class AnimatableArrayController {
  final _AnimatableArrayState _state;
  AnimatableArrayController(this._state);
  Future<void> swipeItems(int index1, int index2) async {
    RenderBox child1Box =
        _state.nodesTextGlobalKeys[index1].currentContext.findRenderObject();
    var child1Offset = child1Box.localToGlobal(Offset.zero);
    RenderBox child2Box =
        _state.nodesTextGlobalKeys[index2].currentContext.findRenderObject();
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
            .animate(_state._animationController);
    Animation<Offset> index2Animation =
        Tween<Offset>(begin: Offset.zero, end: newChild2Offset)
            .animate(_state._animationController);
    void listner() {
      _state.setState(() {
        _state.dxOffsets[index1] = index1Animation.value.dx;
        _state.dyOffsets[index1] = index1Animation.value.dy;
        _state.dxOffsets[index2] = index2Animation.value.dx;
        _state.dyOffsets[index2] = index2Animation.value.dy;
      });
    }

    _state._animationController.addListener(listner);

    await _state._animationController.forward();
    _state._animationController.removeListener(listner);
    _state.setState(() {
      _state.swipeItems(index1, index2);
      _state.dxOffsets[index1] = 0;
      _state.dxOffsets[index2] = 0;
      _state.dyOffsets[index1] = 0;
      _state.dyOffsets[index2] = 0;
    });
    _state._animationController.reset();
  }
}
