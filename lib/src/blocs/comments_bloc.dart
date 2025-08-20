import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
import '../models/item_models.dart';

class CommentsBloc {
  final _repository = Repository();

  // Streams & Subjects
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();

  // Stream getters
  Stream<Map<int, Future<ItemModel?>>> get itemsWithComments => _commentsOutput.stream;

  // Sink getter
  Function(int) get fetchItemsWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    // Transform incoming IDs into fetched items and cache them
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  // Fetch comments and recursively fetch kids
  StreamTransformer<int, Map<int, Future<ItemModel?>>> _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel?>>>(
          (cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        cache[id]!.then((item) {
          item?.kids.forEach((kidId) => fetchItemsWithComments(kidId));
        });
        return cache;
      },
      <int, Future<ItemModel?>>{},
    );
  }

  void dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
