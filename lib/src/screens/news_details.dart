import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/comment.dart';
import '../blocs/comments_provider.dart';
import 'dart:async';
import '../models/item_models.dart';
class NewsDetails extends StatelessWidget{
  final itemId;
  NewsDetails({this.itemId});
  @override
  Widget build(BuildContext context) {
final  bloc = CommentsProvider.of(context);
  return Scaffold(
    appBar: AppBar(
      title: Text('details'),

    ),
    body: buildBody(bloc),
  );
  }

  Widget buildBody(CommentsBloc bloc){

    bloc.fetchItemsWithComments(itemId);

    return StreamBuilder<Map<int, Future<ItemModel?>>>(
        stream: bloc.itemsWithComments,
        builder: (context, snapshot){
if(!snapshot.hasData){
  return Text('loading');
}

if (!snapshot.data!.containsKey(itemId)) {
  return Text('Fetching item $itemId...');
}
final itemFuture= snapshot.data?[itemId];
if(itemFuture ==null){
  return Text('Item not found');
}


return FutureBuilder<ItemModel?>(
    future: itemFuture,
    builder: (context,  itemSnapshot){
      if (!itemSnapshot.hasData){
        return Text('loading ...');
      }
      return buildList(itemSnapshot.data, snapshot.data ??{});
    }
);
        }
    );
  }
 
  Widget buildList(ItemModel? item , Map<int, Future<ItemModel?>> itemMap){
    final children =<Widget>[];
    children.add(buildTitle(item));
    final commentList= item?.kids.map((kidId){
      return Comment(itemId: kidId, itemMap: itemMap, depth: 1,);
    });
    children.addAll(commentList as Iterable<Widget>);
    return ListView(
      children: children
    );
  }


  Widget buildTitle(ItemModel? item){
    if(item==null)
    {Text('Title not loaded');}
    return Container(
      margin: EdgeInsets.all(5),
      alignment: Alignment.topCenter,
      child: Text(
        item!.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }



}