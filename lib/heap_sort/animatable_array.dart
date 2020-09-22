import 'package:flutter/material.dart';

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
  AnimatableArrayController controller;

  void swipeItems(int i1, i2) {
    var t = items[i1];
    items[i1] = items[i2];
    items[i2] = t;
  }

  void initializeAraayProperties() {
    items = widget.items;
    size = items.length;
    nodesTextGlobalKeys = List.generate(size, (_) => GlobalKey());
    nodesTextOffset = List.generate(size, (_) => Offset.zero);
    widget.onArrayCreated(controller);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    controller = AnimatableArrayController(this);
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
                          padding: EdgeInsets.all(3),
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: Transform.translate(
                              offset: nodesTextOffset[k],
                              child: Text(
                                items[k].toString(),
                                key: nodesTextGlobalKeys[k],
                              )),
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
}
