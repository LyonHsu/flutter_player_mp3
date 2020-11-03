import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'GetMp3.dart';
import 'Perimission/Permission.dart';

class GetMp3Permission extends StatefulWidget {
  BuildContext context;
  String title;
  GetMp3Permission({Key key,this.context, this.title}) : super(key: key);
  @override
  _MainHomePageState createState() => _MainHomePageState(title:title);
}

  class _MainHomePageState extends State<GetMp3Permission> {
    String title;
    _MainHomePageState({this.title});
  @override
  void initState() {
    getPermission();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
        ),
        body:Center()
    );
  }
  void getPermission() async{
    bool isOK = await Permission().getPermission(context);
    if(isOK){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => GetMp3fragment(title:title)));

    }else{
      //exit(0);
      Navigator.pop(context);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => GetMp3fragment()));
    }
  }

}