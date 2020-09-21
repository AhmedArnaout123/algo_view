import 'package:flutter/material.dart';

class FixedCircle extends StatelessWidget {
  final Offset center;
  final double radius;
  final Widget child;

  const FixedCircle({Key key, this.center, this.radius, this.child})
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
              border: Border.all(width: 0.5)),
          child: child,
        ));
  }
}
