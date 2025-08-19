import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
import '../models/item_models.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemOutput = BehaviorSubject<Map<int,Future<ItemModel?>>>();
  final _itemFetcher = PublishSubject<int>();


  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int,Future<ItemModel?>>> get items=> _itemOutput.stream;


  Function(int) get fetchItem => _itemFetcher.sink.add;

  StoriesBloc() {
     _itemFetcher.stream.transform(_itemTransformer()).pipe(_itemOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache(){
    return _repository.clearCache();
  }
  void dispose() {
    _topIds.close();
    _itemFetcher.close();
    _itemOutput.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
          (Map<int, Future<ItemModel?>> cache, int id, index) {
            print(index);
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel?>>{},
    );
  }
}