part of 'sorting_bloc.dart';

enum ComparedItemsEventType { ShowComparingIndicator, HideComparingIndicator }

@immutable
abstract class SortingEvent {}

class SwapedItemsSortingEvent extends SortingEvent {
  final int index1;
  final int index2;
  SwapedItemsSortingEvent({@required this.index1, @required this.index2});
}

class ComparedItemsSortingEvent extends SortingEvent {
  final ComparedItemsEventType type;
  final int index1, index2;
  ComparedItemsSortingEvent(
      {@required this.type, @required this.index1, @required this.index2});
}
