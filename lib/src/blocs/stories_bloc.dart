import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
import '../models/item_models.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _items = BehaviorSubject<int>();

  late Stream<Map<int, Future<ItemModel?>>> items;

  Stream<List<int>> get topIds => _topIds.stream;
  Function(int) get fetchItem => _items.sink.add;

  StoriesBloc() {
    items = _items.stream.transform(_itemTransformer());
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  void dispose() {
    _topIds.close();
    _items.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
          (Map<int, Future<ItemModel?>> cache, int id, _) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel?>>{},
    );
  }
}