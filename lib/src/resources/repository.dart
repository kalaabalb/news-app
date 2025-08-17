import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_models.dart';

class Repository {
  final List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  final List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() async {
    return await sources[1].fetchTopIds();
  }

  Future<ItemModel?> fetchItem(int id) async {
    ItemModel? item;

    for (var source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    if (item != null) {
      for (var cache in caches) {
        await cache.addItem(item);
      }
    }

    return item;
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}