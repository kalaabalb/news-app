import 'package:flutter/material.dart';
import 'package:news/src/models/item_models.dart';
import 'package:news/src/widgets/refresh.dart';
import '../blocs/stories_provider.dart';
import '../widgets/loading_container.dart';
import '../widgets/news_list_tile.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    bloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: Refresh(child: _buildList(bloc)),
    );
  }

  Widget _buildList(StoriesBloc bloc) {
    return StreamBuilder<List<int>>(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, int index) {
            final itemId = snapshot.data![index];
            return NewsListTile(itemId: itemId); // Use the separate widget
          },
        );
      },
    );
  }
}