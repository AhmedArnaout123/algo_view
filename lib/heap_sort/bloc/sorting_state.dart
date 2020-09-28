part of 'sorting_bloc.dart';

@immutable
abstract class SortingState {}

class SortingInitial extends SortingState {}

class StableSortingState extends SortingState {}

class SwapingItemsSortingState extends SortingState {
  final int index1, index2;

  SwapingItemsSortingState(this.index1, this.index2);
}

class ComparingItemsInProgressSortingState extends SortingState {
  final int index1, index2;

  ComparingItemsInProgressSortingState(this.index1, this.index2);
}

class ComparingItemsIsDoneSortingState extends SortingState {
  final int index1, index2;

  ComparingItemsIsDoneSortingState(this.index1, this.index2);
}
