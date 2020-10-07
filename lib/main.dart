import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:algo_view/heap_sort/bloc/sorting_bloc.dart';

import 'heap_sort/heap_sort_page.dart';

void main(List<String> args) {
  runApp(
    BlocProvider(
      create: (_) => SortingBloc(),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HeapSortPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
