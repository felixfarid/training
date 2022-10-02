// [315]
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/jobs/empty_content.dart';

//

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    super.key,
    required this.snapshot,
    required this.itemBuilder,
  });
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items!.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return const EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  // instead of using standard ListView constructor
  // which takes our children argument
  // we use this .builder constructor
  // suitable for lists with large items
  // builder called on-the-fly for visible items (as we scroll)
  Widget _buildList(List<T> items) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 0.5),
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(
        context,
        items[index],
      ),
    );
  }
}
