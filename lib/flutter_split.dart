
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSplit {
  static const MethodChannel _channel =
      const MethodChannel('flutter_split');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
