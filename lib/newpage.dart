import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("新的一页"),),
        body: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.greenAccent,
            alignment: Alignment.center,
            width: double.infinity, height: double.infinity,
            child: Text("这是新的一页",
              style: TextStyle(color: Colors.redAccent, fontSize: 30),),)
          ),
        );
  }
}