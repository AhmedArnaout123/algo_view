import 'package:flutter/material.dart';

enum ComparingIndicatorShape { Circle, Rectangle }

class ComparingIndicator extends StatefulWidget {
  final double height;
  final double width;
  final double borderWidth;
  final ComparingIndicatorShape shape;
  const ComparingIndicator(
      {Key key, this.borderWidth, this.height, this.width, this.shape})
      : super(key: key);
  @override
  _ComparingIndicatorState createState() => _ComparingIndicatorState();
}

class _ComparingIndicatorState extends State<ComparingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
      lowerBound: 0.3,
      upperBound: 1,
    );
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    bool isCircleShape = widget.shape == ComparingIndicatorShape.Circle;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) => Opacity(
        opacity: _controller.value,
        child: child,
      ),
      child: Container(
        height: widget.height + widget.borderWidth,
        width:
            (isCircleShape ? widget.height : widget.width) + widget.borderWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            isCircleShape ? (widget.height + widget.borderWidth) : 0,
          ),
          border: Border.all(
            width: widget.borderWidth,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
    _controller.dispose();
  }
}
