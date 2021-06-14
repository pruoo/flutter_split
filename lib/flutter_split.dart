import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_split/split_result.dart';

class FlutterSplit {
  static const MethodChannel _channel = const MethodChannel('flutter_split');

  Future<void> initializeSdk(String appKey, String userId) async {
    Map<String, dynamic> attr = {};
    attr['appKey'] = appKey;
    attr['userId'] = userId;
    return await _channel.invokeMethod('initializeSdk', attr);
  }

  Future<String> getTreatment(String key, Map<String, dynamic> attr) async {
    Map<String, dynamic> attributes = {"key": key, "attributes": attr};

    try {
      return await _channel.invokeMethod('getTreatment', attributes);
    } catch (e, st) {
      print(e);
      print(st);
      return null;
    }
  }

  Future<SplitResult> getTreatmentWithConfig(
      String key, Map<String, dynamic> attr) async {
    Map<String, dynamic> attributes = {"key": key, "attributes": attr};

    try {
      var data =
          await _channel.invokeMethod('getTreatmentWithConfig', attributes);
      return SplitResult.fromJson({
        'splitName': key,
        'treatment': data['treatment'],
        'config': data['config'] == null ? null : jsonDecode(data['config'])
      });
    } catch (e, st) {
      print(e);
      print(st);
      return null;
    }
  }

  Future<Map<String, String>> getTreatments(
      List<String> keys, Map<String, dynamic> attr) async {
    Map<String, dynamic> attributes = {"keys": keys, "attributes": attr};

    var data = await _channel.invokeMethod('getTreatments', attributes);

    Map<String, String> result = Map();
    for (var key in keys) {
      try {
        result[key] = data[key];
      } catch (e, st) {
        print(e);
        print(st);
      }
    }

    return result;
  }

  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      List<String> keys, Map<String, dynamic> attr) async {
    Map<String, dynamic> attributes = {"keys": keys, "attributes": attr};

    var data =
        await _channel.invokeMethod('getTreatmentsWithConfig', attributes);

    Map<String, SplitResult> finalResult = Map();
    data.forEach(
      (key, value) {
        finalResult[key] = SplitResult.fromJson(
          {
            'splitName': key,
            'treatment': value['treatment'],
            'config':
                value['config'] == null ? null : jsonDecode(value['config']),
          },
        );
      },
    );

    return finalResult;
  }

  Future<void> dispose() async {
    return await _channel.invokeMethod('dispose');
  }

  Future<bool> trackEvent(
      String eventType, String trafficType, Map<String, dynamic> props) async {
    return await _channel.invokeMethod('trackEvent', {
      'trafficType': trafficType,
      'eventType': eventType,
      'attributes': props
    });
  }
}
