part of 'sorting_bloc.dart';

@immutable
abstract class SortingState {}

class SortingInitial extends SortingState {}

class StableSortingState extends SortingState {}

class SwapingItemsSortingState extends SortingState {}

class ComparingItemsInProgressSortingState extends SortingState {}

class ComparingItemsIsDoneSortingState extends SortingState {}
