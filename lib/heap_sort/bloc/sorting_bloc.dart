import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sorting_event.dart';
part 'sorting_state.dart';

class SortingBloc extends Bloc<SortingEvent, SortingState> {
  SortingBloc() : super(SortingInitial());

  @override
  Stream<SortingState> mapEventToState(
    SortingEvent event,
  ) async* {
    switch (event.runtimeType) {
      case SwapedItemsSortingEvent:
        yield* _swapedItemsEventHandler(event);
        break;
      case ComparedItemsSortingEvent:
        yield* _comparedItemsEventHandler(event);
    }
  }

  Stream<SortingState> _swapedItemsEventHandler(
      SwapedItemsSortingEvent event) async* {
    yield SwapingItemsSortingState(event.index1, event.index2);
  }
}

Stream<SortingState> _comparedItemsEventHandler(
  ComparedItemsSortingEvent event,
) async* {
  switch (event.type) {
    case ComparedItemsEventType.ShowComparingIndicator:
      yield ComparingItemsInProgressSortingState(event.index1, event.index2);
      break;
    case ComparedItemsEventType.HideComparingIndicator:
      yield ComparingItemsIsDoneSortingState(event.index1, event.index2);
      break;
  }
}
