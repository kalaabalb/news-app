import 'package:flutter/material.dart';
import 'package:news/src/screens/news_details.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      child: MaterialApp(
        title: 'News',
        onGenerateRoute:routes,

      ),
    );
  }
  MaterialPageRoute routes(RouteSettings settings){
if(settings.name=='/'){
  return MaterialPageRoute(
      builder: (context){
        return NewsList();
      }
  );
}
else{
  return MaterialPageRoute(
      builder:(context){
        final itemId= int.parse(settings.name!.replaceAll('/',''));
        return NewsDetails(
          itemId: itemId,
        );
      }
  );
}
}
}