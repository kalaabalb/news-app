import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart';
import 'package:news/src/resources/news_api_provider.dart';

void main(){
test('fetchTopId from the list returned', ()async{
  final newsApi= NewsApiProvider();
  newsApi.client= MockClient((request)async{
    return Response (json.encode([1,2,3,4]),200);
  });
  final ids=  await newsApi.fetchTopIds();
  expect(ids, [1,2,3,4]);

});
test('fetchItem based on the id', () async{
final newApi =NewsApiProvider();
final jsonMap={'id':123};
newApi.client= MockClient((request) async {
  return Response(json.encode(jsonMap), 200);
});
final item= await newApi.fetchItem(900);
expect(item.id, 123);

});

}