import Flutter
import UIKit
import Split

public class SwiftFlutterSplitPlugin: NSObject, FlutterPlugin {

private var client: SplitClient!;

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_split", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSplitPlugin()
    
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "initializeSdk":
      let args = call.arguments as! Dictionary<String, Any>
      // Your Split API-KEY
      let apiKey: String = args["appKey"] as! String
      
      //User Key
      let key: Key = Key(matchingKey: "key")
      //Split Configuration
      let config = SplitClientConfig()
      //Split Factory
      let builder = DefaultSplitFactoryBuilder()
      let factory = builder.setApiKey(apiKey).setKey(key).setConfig(config).build()
      //Split Client
      client = factory?.client
      if(factory===nil){
        result(false)
      }
      else{
        result(true)

      }
      break;
    default:
      break;
      
    }
  }
}
