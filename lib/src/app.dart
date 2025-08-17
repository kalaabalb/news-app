import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';


class App extends StatelessWidget{
Widget build(context){
  return StoriesProvider(
      child: MaterialApp(
        title: 'news',
        home: NewsList(),
      )
  );
}
}