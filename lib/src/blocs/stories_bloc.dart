import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
import '../models/item_models.dart';

class StoriesBloc{
final _repository = repository();
final _topid= PublishSubject<List<int>>();
final _items = BehaviorSubject<int>();

late Stream <Map<int, Future<ItemModel>>> items;

 Stream<List<int>>get topIds =>_topid.stream;

 Function (int) get fetchItem=> _items.sink.add;

 StoriesBloc(){
  items = _items.stream.transform(_itemTransform());
}

 fetchTopIds() async{
   final ids = await _repository.fetchTopId();
   _topid.sink.add(ids);
 }

 void dispose(){
   _topid.close();
   _items.close();
 }

_itemTransform(){
   return ScanStreamTransformer(
       (Map<int, Future<ItemModel?>> cache, int id, _){
         cache[id] = _repository.fetchItem(id);
         return cache;
       } ,
     <int, Future <ItemModel?>>{},
   );
}


}