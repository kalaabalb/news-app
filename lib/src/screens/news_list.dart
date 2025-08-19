import 'package:flutter/material.dart';
import 'package:news/src/models/item_models.dart';
import 'package:news/src/widgets/refresh.dart';
import '../blocs/stories_provider.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    bloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: Refresh(
          child:  _buildList(bloc),
      ),
    );
  }

  Widget _buildList(StoriesBloc bloc) {
    return StreamBuilder<List<int>>(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, int index) {
            final itemId = snapshot.data![index];
            bloc.fetchItem(itemId);

            return StreamBuilder<ItemModel?>(
              stream: bloc.items
                  .asyncMap((map) => map[itemId])
                  .asyncMap((future) => future),
              builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
                if (!itemSnapshot.hasData) {
                  return const SizedBox();
                }
                return buildTile(itemSnapshot.data!);
              },
            );
          },
        );
      },
    );
  }

Widget buildTile(ItemModel item){
  return Column(
    children: [
  ListTile(
    onTap: (){
      print('${item.id} is the id');
    },
  title: Text(item.title),
  subtitle: Text('${item.score} points'),
  trailing: Column(
  children: [
  Icon(Icons.comment),
  Text('${item.descendants}')
  ],

  ),

  )
    ],
  );



}
}
