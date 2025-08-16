import 'dart:convert';
import 'package:news/src/resources/repository.dart';
import 'repository.dart';
import '../models/item_models.dart';
import 'package:http/http.dart' show Client;

final _root= 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source{
  Client client = new Client();

  Future<List<int>> fetchTopId() async {
    final response = await client.get(Uri.parse('$_root/topstories.json'));
    final ids = List<int>.from(json.decode(response.body));
    return ids;
  }


  Future<ItemModel> fetchItem(int ids) async {
    final response = await client.get(Uri.parse('$_root/item/$ids.json'));
    final parsedJson= json.decode(response.body);
return ItemModel.fromJson(parsedJson);
  }


}