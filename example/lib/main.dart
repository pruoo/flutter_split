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
  String _splitStatus = 'Uninitialized.';
  String _treatment;

  final FlutterSplit flutterSplit = FlutterSplit();

  static const SPLIT_NAME = "example_split_name";

  @override
  void initState() {
    super.initState();
    initSplitPlugin();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initSplitPlugin() async {
    //Replace the value with your real key.
    //The example will not work with the default example key.
    const SPLIT_API_KEY = 'default_example_key';

    String splitStatus;

    try {
      await flutterSplit.initializeSdk(SPLIT_API_KEY, "uid");
      splitStatus = 'Initialized';
    } on PlatformException {
      splitStatus = 'Failed to initialize.';
    }

    if (!mounted) return;

    setState(() {
      _splitStatus = splitStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Split.io Flutter Plugin Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Split Plugin Status: $_splitStatus\n',
                    maxLines: 2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Treatment for split $SPLIT_NAME: $_treatment\n',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('EVALUATE SPLIT'),
          onPressed: () async {
            String treatment = await flutterSplit.getTreatment(
                SPLIT_NAME, {"attribute1": 1, "attribute2": "another-value"});
            setState(() {
              _treatment = treatment;
            });
          },
        ),
      ),
    );
  }
}
