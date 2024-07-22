import Foundation
import Vision

class GooturkMethodCallHandler{
    // @@ TODO: Not Implemented
    //    private var myYoloWorldModel: MLModel?
    
    public init() {}

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String : Any] else {
            return
        }
        switch(call.method)
        {
        case "getBatteryLevel":
            receiveBatteryLevel(result: result)
            break
        case "loadModel":
            loadModel(args: args, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func receiveBatteryLevel(result: FlutterResult) -> Void {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true

       if device.batteryState == UIDevice.BatteryState.unknown {
         result(FlutterError(code: "UNAVAILABLE",
                             message: "Battery level not available.",
                             details: nil))
       } else {
         result(Int(device.batteryLevel * 100))
       }
    }

    public func loadModel(args: [String: Any],result: FlutterResult) -> Void{
        // @@TODO: Not Implemented
    }

}
