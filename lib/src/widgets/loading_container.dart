import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget{
  @override

  Widget build( BuildContext context){
    return Column(
      children: [
        ListTile(
          title: buildContainer(),
          subtitle:buildContainer() ,

        ),
      ],
    );
  }
  Widget buildContainer(){
    return Container(
      height: 20.0,
      width: 150.0,
      margin: EdgeInsets.only(top:4.0 ,bottom: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(4)
      ),
    );
  }
}