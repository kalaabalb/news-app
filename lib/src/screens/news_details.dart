import 'package:flutter/material.dart';

class NewsDetails extends StatelessWidget{
  final itemId;
  NewsDetails({this.itemId});
  @override
  Widget build(BuildContext context) {

  return Scaffold(
    appBar: AppBar(
      title: Text('details'),

    ),
    body: Text('$itemId'),
  );
  }
  
}