package com.imumz.flutter_split;

import android.content.Context;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeoutException;

import android.util.Log;

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
import io.split.android.client.dtos.Split;
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

  private static boolean isSDKReady;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_split");
    this.appContext = flutterPluginBinding.getApplicationContext();
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, final @NonNull Result result) {
    if(call.method.equals("initializeSdk")){


      Log.i("split_client_init_1", "split_init");

      isSDKReady = false;
      this.apikey = call.argument("appKey");
      SplitClientConfig config = SplitClientConfig.builder().build();

      // Create a new user key to be evaluated
      this.userId = call.argument("userId");
      Key k = new Key(this.userId);
      // Create factory
      SplitFactory splitFactory = null;
      try {
        splitFactory = SplitFactoryBuilder.build(this.apikey, k, config, this.appContext);
        Log.i("split_client_init_2", "split_init_2");
      } catch (IOException e) {
        e.printStackTrace();
      } catch (InterruptedException e) {
        e.printStackTrace();
      } catch (TimeoutException e) {
        e.printStackTrace();
      } catch (URISyntaxException e) {
        e.printStackTrace();
      }
      
      // Get Split Client instance
      Log.i("split_client_init_3", "split_init_3");      
      this.client = splitFactory.client();

      this.client.on( SplitEvent.SDK_READY,new SplitEventTask() {

        @Override
        public void onPostExecution(SplitClient client) {
          super.onPostExecution(client);
          isSDKReady = true;
          Log.i("split_sdk_ready1", "split_sdk_ready1");
          // result.success(true);
        }

        @Override
        public void onPostExecutionView(SplitClient client) {
          super.onPostExecutionView(client);
          // isSDKReady = true;
          
          Log.i("split_sdk_ready2", "split_sdk_ready2");
          System.out.println("split_sdk_ready2");
          // result.success(true);
        }
      });

        // When definitions were loaded from cache
      this.client.on(SplitEvent.SDK_READY_FROM_CACHE, new SplitEventTask() {
          @Override
          public void onPostExecution(SplitClient client) {
            //Background Code in Here
            // super.onPostExecution(client);
            isSDKReady = true;
            Log.i("split_sdk_ready1", "split_sdk_ready_from_cache " + client.isReady());
          }
          @Override
          public void onPostExecutionView(SplitClient client) {
            //UI Code in Here
          }
        });
        // When the SDK couldn't fetch definitions befor *config.ready* time
      this.client.on(SplitEvent.SDK_READY_TIMED_OUT, new SplitEventTask() {
          @Override
          public void onPostExecution(SplitClient client) {
            //Background Code in Here
            Log.i("split_sdk_ready1", "split_sdk_ready_timed_out");
          }
          @Override
          public void onPostExecutionView(SplitClient client) {
            //UI Code in Here
          }
        });      

    } else if(call.method.equals("trackEvent")){
      String eventType  = call.argument("eventName");
      HashMap<String,Object> map = new HashMap<String,Object>();
      if(this.client!=null){
         boolean res = client.track(eventType,map);
         if(res){
            result.success(true);
         }else{

         }
      }else{
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
    }else if(call.method.equals("getTreatment")){
      String key = call.argument("key");
      HashMap<String,Object> attr = call.argument("attributes");
      if(this.client!=null){
          String treatment = client.getTreatment(key,attr);
          result.success(treatment);
      }else{
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
    }else if(call.method.equals("getTreatmentWithConfig")){
      String key = call.argument("key");
      HashMap<String,Object> attr = call.argument("attributes");
      if(this.client!=null){
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
      if(this.client!=null){
        Map<String, String> treatment = client.getTreatments(keys,attr);
        result.success(treatment);
      }else{
        result.error(SDK_NOT_INITIALIZED,"Sdk is not initialized","");
      }
    }else if(call.method.equals("getTreatmentsWithConfig")){
      List<String> keys = call.argument("keys");
      HashMap<String,Object> attr = call.argument("attributes");
      if(this.client!=null){
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
      if(this.client!=null){
        this.client.destroy();
        result.success(true);
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
