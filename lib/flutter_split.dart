
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_split/split_result.dart';

class FlutterSplit {
  static const MethodChannel _channel =
      const MethodChannel('flutter_split');

  Future<void> initializeSdk(String appKey)async{
    Map<String,dynamic> attr = {};
    attr['appKey'] = appKey;
    await _channel.invokeMethod('initializeSdk',attr);
  }

  Future<String>  getTreatment(String key,Map<String,dynamic> attr)async{
    Map<String,dynamic> attributes = {
      "key":key,
      "attributes":attr
    };
    try{
      return await _channel.invokeMethod('getTreatment',attributes);
    }catch(e,st){
      print(e);
      print(st);
      return null;
    }
  }

  Future<SplitResult>  getTreatmentWithConfig(String key,Map<String,dynamic> attr)async{
    Map<String,dynamic> attributes = {
      "key":key,
      "attributes":attr
    };
    try{
      var data =  await _channel.invokeMethod('getTreatmentWithConfig',attributes);
      return SplitResult.fromJson({'splitName':key,'treatment':data['treatment'],'config':jsonDecode(data['config'])});
    }catch(e,st){
      print(e);
      print(st);
      return null;
    }
  }

  Future<Map<String,String>>  getTreatments(List<String> keys, Map<String,dynamic> attr)async{
    Map<String,dynamic> attributes = {
      "keys":keys,
      "attributes":attr
    };
    Map<String,String> data =  await _channel.invokeMethod('getTreatments',attributes);
    return data;
  }

  Future<List<SplitResult>>  getTreatmentsWithConfig(List<String> keys, Map<String,dynamic> attr)async{
    Map<String,dynamic> attributes = {
      "keys":keys,
      "attributes":attr
    };
    Map<String,dynamic> data =  await _channel.invokeMethod('getTreatments',attributes);
    List<SplitResult> result = [];
    data.forEach((key, value) { 
      result.add(SplitResult.fromJson({'splitName':key,'treatment':value['treatment']}));
    });
  }

  Future<void> dispose()async{
    await _channel.invokeMethod('dispose');
  }

  static Future<bool> trackEvent(String eventName,Map<String,dynamic> props)async{

  }
}
