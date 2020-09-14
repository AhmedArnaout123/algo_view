import 'package:algo_view/heap_sort/complete_binary_tree.dart';
import 'package:algo_view/heap_sort/heap_sort.dart';
import 'package:algo_view/heap_sort/line.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<GlobalKey> _textGlobalkeys = List.generate(8, (i) => GlobalKey());
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  Offset p1 = Offset(169, 79);
  Offset p2 = Offset(80, 288);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Line(
            start: Offset(21, 15),
            end: Offset(89, 88),
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}
// Stack(
//       children: <Widget>[
//         Container(
//           color: Colors.red.withOpacity(0.2),
//         ),
//         Transform.translate(
//           offset: p1,
//           child: Container(
//             key: _textGlobalkeys[0],
//             height: 10,
//             width: 10,
//             color: Colors.white,
//           ),
//         ),
//         Transform.translate(
//           offset: p2,
//           child: Container(
//             key: _textGlobalkeys[1],
//             width: 10,
//             height: 10,
//             color: Colors.green,
//           ),
//         ),
//         Positioned(
//           bottom: 10,
//           child: Row(
//             children: <Widget>[
//               RaisedButton(
//                 child: Text('white'),
//                 onPressed: () {
//                   RenderBox r =
//                       _textGlobalkeys[0].currentContext.findRenderObject();
//                   var pos = r.localToGlobal(Offset(10, 0));
//                   print("position white:(${pos.dx}, ${pos.dy})");
//                   var s = r.size;
//                   print("size white $s");
//                 },
//               ),
//               RaisedButton(
//                 child: Text('green'),
//                 onPressed: () {
//                   RenderBox r =
//                       _textGlobalkeys[1].currentContext.findRenderObject();
//                   var pos = r.localToGlobal(Offset(10, 0));
//                   print("position green:(${pos.dx}, ${pos.dy})");
//                   var s = r.size;
//                   print("size green $s");
//                 },
//               ),
//               RaisedButton(
//                 child: Text('Animate'),
//                 onPressed: () async {
//                   var mov =
//                       Tween<Offset>(begin: p1, end: p2).animate(_controller);
//                   _controller.addListener(() {
//                     var dx = mov.value.dx - p1.dx;
//                     var dy = mov.value.dy - p1.dy;
//                     print("($dx, $dy)");
//                     p1 = mov.value;
//                     print(p1);
//                     p2 = p2 - Offset(dx, dy);
//                     setState(() {});
//                   });
//                   await _controller.forward();
//                   print('end');
//                 },
//               )
//             ],
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//           ),
//         )
//       ],
//     ));
