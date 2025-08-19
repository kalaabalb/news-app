import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../blocs/stories_provider.dart';
import '../models/item_models.dart';
import 'loading_container.dart';
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
          return LoadingContainer();
        }

        final futureItem = snapshot.data![itemId];

        return FutureBuilder<ItemModel?>(
          future: futureItem,
          builder: (context, itemSnapshot)  {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }
            return Text(itemSnapshot.data?.title ?? 'No title');
          },
        );
      },
    );
  }
}