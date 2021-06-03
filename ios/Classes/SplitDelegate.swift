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
    
    
    public func getTreatment(splitName: String,attributes: [String:Any], result: @escaping FlutterResult){
        
        self.client?.on(event: SplitEvent.sdkReady) {
            let treatment = self.client?.getTreatment(splitName, attributes: attributes)
            result(treatment)
        }
        
        self.client?.on(event: SplitEvent.sdkReadyTimedOut) {
            result(nil)
            print("SDK time out")
        }
    }
    
    
}
