import 'package:flutter/widgets.dart';

class UISortingDataProvider {
  List<int> items;
  List<Offset> itemsWidgetsOffsets;
  List<GlobalKey> itemsWidgetsGlobalKeys;
  List<bool> haveItemsComparingIndicators;

  UISortingDataProvider({@required List<int> items}) {
    initilizeData(items);
  }

  int get size => items.length;

  void initilizeData(List<int> items) {
    this.items = List.from(items);
    haveItemsComparingIndicators = List.generate(size, (index) => false);
    itemsWidgetsGlobalKeys = List.generate(size, (index) => GlobalKey());
    itemsWidgetsOffsets = List.generate(size, (index) => Offset(0, 0));
  }

  void swapItems(i, j) {
    int t = items[i];
    items[i] = items[j];
    items[j] = t;
  }
}
