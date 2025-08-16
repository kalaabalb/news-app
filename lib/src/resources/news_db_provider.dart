import 'dart:js_interop';

import 'package:news/src/resources/repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import 'repository.dart';
import '../models/item_models.dart';

class NewsDbProvider implements Source, Cache{
  late Database Db;
  Future<List<int>>? fetchTopId(){
    return null;
  }


  void init ()async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path= join(documentDirectory.path,"items.db");
    Db= await  openDatabase(
        path,
      version: 1,
      onCreate: (Database newDb,int version){
          newDb.execute("""
            Create Table items(
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
      }
    );
  }
Future <ItemModel?> fetchItem (int id) async {
    final maps= await Db.query(
      "items",
      columns: null,
      where: "id= ?",
      whereArgs:[id],
    );
    if(maps.length >0){
return ItemModel.fromDb(maps.first);
    }

    return null;


}

Future <int> addItem (ItemModel item){
   return  Db.insert("items", item.toMap());
}

}

NewsDbProvider newsDpProvider= NewsDbProvider();