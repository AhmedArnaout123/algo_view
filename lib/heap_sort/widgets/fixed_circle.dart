import 'package:flutter/material.dart';

class FixedCircle extends StatelessWidget {
  final Offset center;
  final double radius;
  final Widget child;
  final Border border;

  const FixedCircle(
      {Key key, this.center, this.radius, this.child, this.border})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: center - Offset(radius, radius),
      child: Container(
        height: 2 * radius,
        width: 2 * radius,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: border,
        ),
        child: child,
      ),
    );
  }
}
