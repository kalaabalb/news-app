import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_models.dart';

class Comment extends StatelessWidget{
  final int itemId;
  final int depth;
  final Map<int, Future<ItemModel?>> itemMap;
  Comment({required this.itemId,required this.itemMap, required this.depth});


  @override
  Widget build(BuildContext context) {
return FutureBuilder(
    future: itemMap[itemId],
    builder: (context, AsyncSnapshot<ItemModel?> snapshot){
if(!snapshot.hasData){

  return  LoadingContainer();

}
final item= snapshot.data;
final children=<Widget>[
  ListTile(
    title:Text(buildItem(item!)),
    subtitle: item.by =="" ? Text('delated'): Text(item.by),
    contentPadding: EdgeInsets.only(
      right: 16.0,
      left: depth+16
    ),
  ),
  Divider()
];
snapshot.data?.kids.forEach((kidId){
  children.add(
    Comment(itemId: kidId, itemMap: itemMap, depth: depth + 1)
  );
});


return Column(
  children: children,

);
    }
);
  }

  String buildItem(ItemModel item){
    final text = item.text.replaceAll('&#x27;', "'").replaceAll('<p>',"\n\n").replaceAll('</p>',"");
    return text;
  }


}