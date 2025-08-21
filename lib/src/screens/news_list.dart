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

            return Dismissible(
              key: Key(itemId.toString()),
                direction: DismissDirection.endToStart,
              onDismissed: (direction){
                Navigator.pushNamed(
                    context,
                    '/${itemId.toString()}');
              },
              background: Container(
                color: Colors.blue,
                alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
              ),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners for the card
                ),
                child: NewsListTile(itemId: itemId), // Embed the custom NewsListTile here
              ),
             // Your custom tile inside the Card
            ); // Use the separate widget
          },
        );
      },
    );
  }
}