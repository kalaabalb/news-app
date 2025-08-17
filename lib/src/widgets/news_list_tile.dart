import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../models/item_models.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  const NewsListTile({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder<Map<int, Future<ItemModel?>>>(
      stream: bloc.items,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.containsKey(itemId)) {
          return const Text('Loading...');
        }

        final futureItem = snapshot.data![itemId];

        return FutureBuilder<ItemModel?>(
          future: futureItem,
          builder: (context, itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Loading item $itemId...');
            }
            return Text(itemSnapshot.data?.title ?? 'No title');
          },
        );
      },
    );
  }
}