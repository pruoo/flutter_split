import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_split/flutter_split.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterSplit flutterSplit = FlutterSplit();

  @override
  void initState() {
    flutterSplit.initializeSdk("52bo50e6gavj7dpma3b0l5j2vpqep0f146nj",'abc1234');
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton(onPressed: ()async{
              print(await flutterSplit.getTreatment('banner_exp', {
                "Name":"Shantanu",
                "Email":"abc@gmail.com",
                "email":"abc@gmail.com",
              }));
            }, child: Text('treatment'))
          ],
        ),
      ),
    );
  }
}
