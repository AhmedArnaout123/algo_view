import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  final Offset start;
  final Offset end;
  final Color color;
  const Line({Key key, this.start, this.end, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double slope = (end.dy - start.dy) / (end.dx - start.dx);
    double dxOffset = slope > 0 ? -(end.dx - start.dx).abs() : 0;
    return Transform.translate(
      offset: Offset(dxOffset, 0),
      child: ClipPath(
        clipper: _LineClipper(
          start,
          end,
        ),
        child: Container(
          height: (end.dy - start.dy).abs(),
          width: (end.dx - start.dx).abs(),
          color: color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class _LineClipper extends CustomClipper<Path> {
  final Offset start;
  final Offset end;

  _LineClipper(
    this.start,
    this.end,
  );
  @override
  getClip(Size size) {
    double slope = (end.dy - start.dy) / (end.dx - start.dx);

    Path path = Path();
    if (slope <= 0) {
      path.lineTo(1, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width - 1, size.height);
      path.lineTo(0, 0);
    }
    if (slope > 0) {
      path.moveTo(0, size.height);
      path.lineTo(1, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(size.width - 1, 0);
      path.lineTo(0, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
