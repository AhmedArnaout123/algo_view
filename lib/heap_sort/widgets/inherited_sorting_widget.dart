import 'package:flutter/material.dart';
import 'package:algo_view/heap_sort/models/ui_sorting_data_provider.dart';

class InheritedSortingWidget extends InheritedWidget {
  final UISortingDataProvider uiSortingDataProvider;
  // final Widget child;

  InheritedSortingWidget({
    @required this.uiSortingDataProvider,
    @required child,
  }) : super(child: child);

  static InheritedSortingWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedSortingWidget>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
