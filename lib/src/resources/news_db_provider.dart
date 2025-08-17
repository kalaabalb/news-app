import 'package:news/src/resources/repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import '../models/item_models.dart';

class NewsDbProvider implements Source, Cache {
  late Database db;

  NewsDbProvider() {
    init();
  }

  Future<void> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE items(
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            deleted INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        """);
      },
    );
  }

  @override
  Future<List<int>> fetchTopIds() async => [];

  @override
  Future<ItemModel?> fetchItem(int id) async {
    final maps = await db.query(
      "items",
      where: "id = ?",
      whereArgs: [id],
    );
    return maps.isNotEmpty ? ItemModel.fromDb(maps.first) : null;
  }

  @override
  Future<int> addItem(ItemModel item) {
    return db.insert("items", item.toMap());
  }
}

final newsDbProvider = NewsDbProvider();