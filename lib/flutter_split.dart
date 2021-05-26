
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSplit {
  static const MethodChannel _channel =
      const MethodChannel('flutter_split');

  Future<void> initializeSdk(String appKey)async{
    Map<String,dynamic> attr = {};
    attr['appKey'] = appKey;
    await _channel.invokeMethod('initializeSdk',attr);
  }

  Future<Map<String,dynamic>>  getTreatment(String key,Map<String,dynamic> attr)async{
    Map<String,dynamic> attributes = {
      "key":key,
      "attributes":attr
    };
    return await _channel.invokeMethod('getTreatment',attributes);
  }

  Future<String>  getTreatments(List<String> keys, Map<String,dynamic> attr)async{
    Map<String,dynamic> attributes = {
      "keys":keys,
      "attributes":attr
    };
    return await _channel.invokeMethod('getTreatments',attributes);
  }

  Future<void> dispose()async{
    await _channel.invokeMethod('dispose');
  }

  static Future<bool> trackEvent(String eventName,Map<String,dynamic> props)async{

  }
}
