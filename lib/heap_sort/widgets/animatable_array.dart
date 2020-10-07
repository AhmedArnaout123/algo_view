import 'package:flutter/material.dart';

import 'package:algo_view/heap_sort/comparing_indicator.dart';
import 'package:algo_view/heap_sort/sorting_widget.dart';

class AnimatableArray extends StatelessWidget {
  final Duration comparingIndicatorDuration;

  const AnimatableArray({
    Key key,
    this.comparingIndicatorDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UISortingDataProvider sortingDataProvider =
        InheritedSortingWidget.of(context).uiSortingDataProvider;
    return Container(
      height: 150,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 0,
        children: [
          ...sortingDataProvider.items
              .asMap()
              .map((k, v) => MapEntry(
                    k,
                    Flex(
                      direction: Axis.vertical,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: Text('${k.toString()}'),
                        ),
                        Container(
                          width: 50,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Transform.translate(
                                  offset: sortingDataProvider
                                      .itemsWidgetsOffsets[k],
                                  child: Text(
                                    sortingDataProvider.items[k].toString(),
                                    key: sortingDataProvider
                                        .itemsWidgetsGlobalKeys[k],
                                  ),
                                ),
                              ),
                              if (sortingDataProvider
                                  .haveItemsComparingIndicators[k])
                                LayoutBuilder(
                                  builder: (_, c) => ComparingIndicator(
                                    borderWidth: 2,
                                    height: c.maxHeight,
                                    width: c.maxWidth,
                                    shape: ComparingIndicatorShape.Rectangle,
                                    animationDuration:
                                        comparingIndicatorDuration,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
              .values
        ],
      ),
    );
  }
}
