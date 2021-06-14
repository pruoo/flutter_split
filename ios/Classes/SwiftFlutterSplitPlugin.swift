import Flutter
import UIKit
import Split

public class SwiftFlutterSplitPlugin: NSObject, FlutterPlugin {
    private var splitDelegate: SplitDelegate = SplitDelegate()
    private static var channelName = "flutter_split";
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterSplitPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "initializeSdk":
            let args = call.arguments as! Dictionary<String, Any>
            // Split API Key
            let apiKey: String = args["appKey"] as! String            
            // User id as Key
            let user: Key = Key(matchingKey: args["userId"] as! String)
            
            splitDelegate.initializeSdk(
                apiKey: apiKey,
                user: user,
                result: result
            );
            
            break;
            
        case "dispose":
            splitDelegate.dispose(result:result)
            break;
            
        case "getTreatment":
            let args = call.arguments as! Dictionary<String, Any>
            let splitName: String = args["key"] as! String
            let attributes: [String:Any] = args["attributes"] as! [String:Any]
            
            splitDelegate.getTreatment(
                splitName: splitName,
                attributes: attributes,
                result: result
            );
            
            break;
            
            
        case "getTreatments":
            let args = call.arguments as! Dictionary<String, Any>
            let splitNames: [String] = args["keys"] as! [String]
            let attributes: [String:Any] = args["attributes"] as! [String:Any]
            
            splitDelegate.getTreatments(splitNames: splitNames,attributes: attributes,result: result)
            break; 
            
            
        case "getTreatmentWithConfig":
            
            let args = call.arguments as! Dictionary<String, Any>
            let splitName: String = args["key"] as! String
            let attributes: [String:Any] = args["attributes"] as! [String:Any]
            
            splitDelegate.getTreatmentWithConfig(splitName: splitName,attributes: attributes,result: result)
            break;
            
        case "getTreatmentsWithConfig":
            
            let args = call.arguments as! Dictionary<String, Any>
            let splitNames: [String] = args["keys"] as! [String]
            let attributes: [String:Any] = args["attributes"] as! [String:Any]
            
            splitDelegate.getTreatmentsWithConfig(splitNames: splitNames,attributes: attributes,result: result)
            break;
            
            
        case "trackEvent":
            
            let args = call.arguments as! Dictionary<String, Any>
            let eventName: String = args["eventName"] as! String
            let properties: [String:Any] = args["properties"] as! [String:Any]
            
            // splitDelegate.trackEvent(eventName: eventName,properties: properties,result: result)
            break;
            
        default:
            break;
            
        }
    }
}
