
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSplit {
  static const MethodChannel _channel =
      const MethodChannel('flutter_split');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> initializeSdk(String appKey)async{
    Map<String,dynamic> attr = {};
    attr['appKey'] = appKey;
    await _channel.invokeMethod('initializeSdk',attr);
  }

  Future<String>  getTreatment(String key,Map<String,dynamic> attr)async{
    Map<String,dynamic> attributes = {
      "kes":key,
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
