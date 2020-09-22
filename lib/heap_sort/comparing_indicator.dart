import 'package:flutter/material.dart';

class ComparingIndicator extends StatefulWidget {
  final double nodeDiameter;
  final double borderWidth;

  const ComparingIndicator({Key key, this.nodeDiameter, this.borderWidth})
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) => Opacity(
        opacity: _controller.value,
        child: child,
      ),
      child: Container(
        height: widget.nodeDiameter + widget.borderWidth,
        width: widget.nodeDiameter + widget.borderWidth,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(widget.nodeDiameter + widget.borderWidth),
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
