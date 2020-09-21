import 'package:algo_view/heap_sort/complete_binary_tree.dart';
import 'package:algo_view/heap_sort/heap_sort.dart';
import 'package:algo_view/heap_sort/line.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
  int treeSize = 8;
  List<int> items;
  CompleteBinaryTreeController _controller;
  @override
  void initState() {
    super.initState();
    randomizeItems();
  }

  void randomizeItems() {
    items = List.generate(treeSize, (index) => math.Random().nextInt(999));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Color(0xff00003f),
              child: Row(
                children: [
                  Text(
                    'Size:',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton<int>(
                    value: treeSize,
                    onChanged: (_) {
                      setState(() {
                        treeSize = _;
                        randomizeItems();
                      });
                    },
                    items: List.generate(
                      14,
                      (index) => DropdownMenuItem(
                        value: index + 4,
                        child: Text((index + 4).toString(),
                            style: TextStyle(
                              color: Colors.blueAccent,
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        color: Colors.yellow,
                        child: Text('Randomize Items'),
                        onPressed: () {
                          setState(() {
                            randomizeItems();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10)
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 10),
              height: 300,
              child: CompleteBinaryTree(
                initialItems: items,
                onTreeCreated: (c) {
                  _controller = c;
                },
              ),
            ),
            RaisedButton(
              onPressed: () async {
                await _controller.swipeItems(2, 9);
              },
            ),
          ],
        ),
      ),
    );
  }
}
