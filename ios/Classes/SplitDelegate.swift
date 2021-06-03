import Flutter
import Split

public class SplitDelegate : NSObject{
    
    private var client: SplitClient?;
    
    public func initializeSdk(_ appKey :  String, withUser userKey  :Key){
        //Split Configuration
        let config = SplitClientConfig()
        //Split Factory
        let builder = DefaultSplitFactoryBuilder()
        let factory = builder.setApiKey(_).setKey(withUser).setConfig(config).build()
        //Split Client
        client = factory?.client
        client?.on(event: SplitEvent.sdkReady){
            result(nil)
            print("!! Split init !!")
        }
        client?.on(event: SplitEvent.sdkReadyTimedOut) {
            result(nil)
            print("!! Split SDK timed out !!")
        }
    }

}
