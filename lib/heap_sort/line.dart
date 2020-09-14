import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  final Offset start;
  final Offset end;
  final Color color;
  const Line({Key key, this.start, this.end, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _LineClipper(
        start,
        end,
      ),
      child: Container(
        height: (end.dy - start.dy).abs(),
        width: (end.dx - start.dx).abs(),
        color: color ?? Theme.of(context).primaryColor,
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
    Path path = Path();
    path.lineTo(1, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 1, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
