import Flutter
import Split

public class SplitDelegate : NSObject {
    
    private var client: SplitClient?;
    
    public func initializeSdk(apiKey : String, user : Key, result : @escaping FlutterResult){
        
        //Config
        let config = SplitClientConfig()
        
        //Factory
        let builder = DefaultSplitFactoryBuilder()
        let factory = builder.setApiKey(apiKey).setKey(user).setConfig(config).build()
        
        //Client
        client = factory?.client
        
        self.client?.on(event: SplitEvent.sdkReady){
            result(nil)
            print("!! Split init !!")
        }
        
        self.client?.on(event: SplitEvent.sdkReadyTimedOut) {
            result(nil)
            print("!! Split SDK timed out !!")
        }
    }
    
    public func dispose(result: @escaping FlutterResult){
        self.client?.destroy();
        result(nil);
    }
    
    
    public func getTreatment(splitName: String,attributes: [String:Any], result: @escaping FlutterResult){
        let treatment = self.client?.getTreatment(splitName, attributes: attributes)
        result(treatment)      
    }
    
    public func getTreatmentWithConfig(splitName: String,attributes: [String:Any], result: @escaping FlutterResult){
        
        let splitResult = self.client?.getTreatmentWithConfig(splitName, attributes: attributes)
        let config = try? JSONSerialization.jsonObject(with: splitResult!.config!.data(using: .utf8)!, options: []) as? [String: Any]
        let treatment = splitResult?.treatment
        
        var flutterResult: [String: Any] = [:]
        flutterResult["treatment"]=treatment;
        flutterResult["config"]=try? String(data:JSONSerialization.data(withJSONObject:config!) as! Data,encoding: .utf8);
        
        result(flutterResult)
        
        
    }
    
    public func getTreatments(splitNames: [String],attributes: [String:Any], result: @escaping FlutterResult){
        
        
        let treatments = self.client?.getTreatments(splits: splitNames, attributes: attributes)
        result(treatments)
        
    }
    
        public func getTreatmentsWithConfig(splitNames: [String],attributes: [String:Any], result: @escaping FlutterResult){
    
                let splitResult = self.client?.getTreatmentsWithConfig(splits: splitNames, attributes: attributes)
                print(splitResult)

        var flutterResult: [String: Any] = [:]

       for split in splitResult!{
            let treatment = split.value.treatment;
            let config = try? JSONSerialization.jsonObject(with: split.value.config!.data(using: .utf8)!, options: []) as? [String: Any]
            
            flutterResult[split.key]=["treatment":treatment,"config":try? String(data:JSONSerialization.data(withJSONObject:config!) as! Data,encoding: .utf8)];
            
        }

                result(flutterResult)
        }
    
    
}
