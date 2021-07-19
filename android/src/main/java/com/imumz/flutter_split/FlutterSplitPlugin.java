package com.imumz.flutter_split;

import android.content.Context;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeoutException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.split.android.client.SplitClient;
import io.split.android.client.SplitClientConfig;
import io.split.android.client.SplitFactory;
import io.split.android.client.SplitFactoryBuilder;
import io.split.android.client.SplitResult;
import io.split.android.client.api.Key;
import io.split.android.client.events.SplitEvent;
import io.split.android.client.events.SplitEventTask;

/** FlutterSplitPlugin */
public class FlutterSplitPlugin implements FlutterPlugin, MethodCallHandler {

  private MethodChannel channel;
  private Context appContext;


  private String apikey;
  private String userId;


  //Split
  private SplitClient client;

  // error codes
  private static String SDK_NOT_INITIALIZED = "SNI001";


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_split");
    this.appContext = flutterPluginBinding.getApplicationContext();
    channel.setMethodCallHandler(this);
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if(call.method.equals("initializeSdk")){
      this.apikey = call.argument("appKey");
      SplitClientConfig config = SplitClientConfig.builder().build();

      // Create a new user key to be evaluated
      this.userId = call.argument("userId");
      Key k = new Key(this.userId);
      // Create factory
      SplitFactory splitFactory = null;
      try {
        System.out.println("INIT SPLIT SDK ");
        splitFactory = SplitFactoryBuilder.build(this.apikey, k, config, this.appContext);
        this.client = splitFactory.client();
        System.out.println("SPLITFACTORYRESULT "+client.isReady());
        result.success(true);
      } catch (IOException e) {
        e.printStackTrace();
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      } catch (InterruptedException e) {
        e.printStackTrace();
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      } catch (TimeoutException e) {
        e.printStackTrace();
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      } catch (URISyntaxException e) {
        e.printStackTrace();
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
      // Get Split Client instance


      this.client.on(SplitEvent.SDK_READY,new SplitEventTask(){

        @Override
        public void onPostExecution(SplitClient client) {
          System.out.println("FLUTTERSPLIT SDK_READY "+client.isReady());
        }

      });

      this.client.on(SplitEvent.SDK_READY_FROM_CACHE,new SplitEventTask(){
        @Override
        public void onPostExecution(SplitClient client) {
          System.out.println("FLUTTERSPLIT SDK_READY_FROM_CACHE "+client.isReady());
        }

      });
      this.client.on(SplitEvent.SDK_READY_TIMED_OUT,new SplitEventTask(){
        @Override
        public void onPostExecution(SplitClient client) {
          System.out.println("FLUTTERSPLIT SDK_READY_TIMED_OUT "+client.isReady());
        }

      });
      this.client.on(SplitEvent.SDK_UPDATE,new SplitEventTask(){
        @Override
        public void onPostExecution(SplitClient client) {
          System.out.println("FLUTTERSPLIT SDK_UPDATE");
        }

      });

      result.success(null);
    
    }else if(call.method.equals("getTreatment")){
      String key = call.argument("key");
      HashMap<String,Object> attr = call.argument("attributes");
      if(this.client.isReady()){
        String treatment = client.getTreatment(key,attr);
        result.success(treatment);
      }else{
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
    }else if(call.method.equals("getTreatmentWithConfig")){
      String key = call.argument("key");
      HashMap<String,Object> attr = call.argument("attributes");
      if(this.client.isReady()){
        SplitResult treatment = client.getTreatmentWithConfig(key,attr);
        Map<String,Object> map = new HashMap<>();
        map.put("config",treatment.config());
        map.put("treatment",treatment.treatment());
        result.success(map);
      }else{
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
    }else if(call.method.equals("getTreatments")){
      List<String> keys = call.argument("keys");
      HashMap<String,Object> attr = call.argument("attributes");
      if(this.client.isReady()){
        Map<String, String> treatment = client.getTreatments(keys,attr);
        result.success(treatment);
      }else{
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
    }else if(call.method.equals("getTreatmentsWithConfig")){
      List<String> keys = call.argument("keys");
      HashMap<String,Object> attr = call.argument("attributes");
      if(this.client.isReady()){
        Map<String, SplitResult> treatment = client.getTreatmentsWithConfig(keys,attr);
        Map<String,Map<String,Object>> finalResult = new HashMap<>();
        for (Map.Entry<String,SplitResult> entry : treatment.entrySet()){
          Map<String,Object> map = new HashMap<>();
          map.put("config",entry.getValue().config());
          map.put("treatment",entry.getValue().treatment());
          finalResult.put(entry.getKey(),map);
        }
        result.success(finalResult);
      }else{
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
    }else if(call.method.equals("dispose")){
      if(this.client.isReady()){
        this.client.destroy();
        result.success(true);
      }else{
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
    }else if(call.method.equals("trackEvent")){
      if(this.client.isReady()){
        String trafficType = call.argument("trafficType");
        String eventType = call.argument("eventType");
        HashMap<String,Object> attr = call.argument("attributes");
        boolean trackResult = this.client.track(trafficType,eventType,attr);
        result.success(trackResult);
      }else{
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}