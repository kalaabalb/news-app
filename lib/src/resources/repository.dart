import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_models.dart';

class repository{
List <Source> sources = <Source>[
  newsDpProvider,
  NewsApiProvider()

];

List<Cache> caches=<Cache>[
  newsDpProvider
];


Future <List<int>>? fetchTopId(){
  return sources[1].fetchTopId();

  }
  Future <ItemModel?> fetchItem(int id) async {
    ItemModel? item;
    Source source;

    for(source in sources){
      item = await source.fetchItem(id);
      if(item != null){
        break;
      }

    }


    for(var cache in caches){
      cache.addItem(item!);
    }
    return item;

  }

}

abstract class Source {
 Future<List<int>>? fetchTopId();
  Future <ItemModel?> fetchItem(int id);
}
abstract class Cache{
 Future<int> addItem(ItemModel item);
}

