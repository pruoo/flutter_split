import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_split_sdk/flutter_split.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _splitStatus = 'Uninitialized.';
  late String _treatment, _treatmentWithConfig;
  late Map<String, dynamic> _config, _treatments, _treatmentsWithConfig;
  late bool _eventTracked;

  static const SPLIT_NAME_1 = "split_example_1";
  static const SPLIT_NAME_2 = "split_example_2";
  static const EVENT = "example_event";
  static const TRAFFIC_TYPE = "user";

  //Instantiate the plugin
  final FlutterSplit flutterSplit = FlutterSplit();

  @override
  void initState() {
    super.initState();
    initSplitPlugin();
  }

  // Initialize the [FlutterSplit] instance with API Key and User id
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Split Plugin Status: $_splitStatus\n',
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                Text(
                  '1. Treatment for split $SPLIT_NAME_1: $_treatment\n',
                  maxLines: 3,
                ),
                SizedBox(height: 8),
                Text(
                  '2. Treatment for split $SPLIT_NAME_1 with config : $_treatmentWithConfig, $_config\n',
                  maxLines: 16,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  '3. Treatments for splits : $_treatments\n',
                  maxLines: 16,
                ),
                SizedBox(height: 8),
                Text(
                  '4. Treatments with config for splits: $_treatmentsWithConfig\n',
                  maxLines: 16,
                ),
                SizedBox(height: 8),
                Text(
                  '5. Event $EVENT tracked : $_eventTracked\n',
                  maxLines: 3,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              label: Text('1. EVALUATE SPLIT'),
              onPressed: () async {
                String treatment =
                    await flutterSplit.getTreatment(SPLIT_NAME_1, {}) ?? '';
                setState(() {
                  _treatment = treatment;
                });
              },
            ),
            SizedBox(height: 8),
            FloatingActionButton.extended(
              label: Text('2. EVALUATE SPLIT WITH CONFIG'),
              onPressed: () async {
                var result =
                    await flutterSplit.getTreatmentWithConfig(SPLIT_NAME_1, {});
                setState(() {
                  _treatmentWithConfig = result?.treatment ?? '';
                  _config = result?.config ?? {};
                });
              },
            ),
            SizedBox(height: 8),
            FloatingActionButton.extended(
              label: Text('3. EVALUATE MULTIPLE SPLITS'),
              onPressed: () async {
                var result = await flutterSplit
                    .getTreatments([SPLIT_NAME_1, SPLIT_NAME_2], {});
                setState(() {
                  _treatments = result;
                });
              },
            ),
            SizedBox(height: 8),
            FloatingActionButton.extended(
              label: Text('4. EVALUATE MULTIPLE SPLITS WITH CONFIG'),
              onPressed: () async {
                var result = await flutterSplit
                    .getTreatmentsWithConfig([SPLIT_NAME_1, SPLIT_NAME_2], {});
                setState(() {
                  _treatmentsWithConfig = result;
                });
              },
            ),
            SizedBox(height: 8),
            FloatingActionButton.extended(
              label: Text('5. TRACK EVENT'),
              onPressed: () async {
                var result =
                    await flutterSplit.trackEvent(EVENT, TRAFFIC_TYPE, {});
                setState(() {
                  _eventTracked = result ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
