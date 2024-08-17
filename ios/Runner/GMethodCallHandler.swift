import Foundation
import Vision
import CoreML

class GooturkMethodCallHandler{
    private var myYoloWorldModel: MLModel?
    private var detector: VNCoreMLModel?
    private var screenSize: CGSize?
    private var screenOrientation: UIDeviceOrientation?
    private var createdAt: Date?
    
    public init() {
        createdAt = Date()
    }

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
        case "debug":
            debugg(args: args, result: result)
            break
        case "inferenceImage":
            Task{
                await detectImage(args: args, result: result)
            }
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func receiveBatteryLevel(result: @escaping FlutterResult) -> Void {
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

    public func compileModel(modelPath: String) throws -> Void{
        let url = try! MLModel.compileModel(at: URL(fileURLWithPath: modelPath))
        myYoloWorldModel = try! MLModel(contentsOf: url)
        return
    }
    
    public func loadModel(args: [String: Any],result: @escaping FlutterResult) -> Void{
        let flutterError = FlutterError(
                    code: "ModelLoadError",
                    message: "Invalid model",
                    details: nil)
        
        guard let modelPath = args["model"] as? String else {
                    result(flutterError)
                    return
                }
        
        if (myYoloWorldModel == nil)
        {
            do {
                try compileModel(modelPath: modelPath)
            }
            catch{
                print(error)
                result(flutterError)
                return
            }
        }
        if (detector == nil){
            do {
                detector = try VNCoreMLModel(for: myYoloWorldModel!)
            }
            catch{
                print(error)
                result(flutterError)
                return
            }
        }
        result(true)
        return
    }
    
    
    public func debugg(args: [String: Any],result: @escaping FlutterResult) -> Void{
//        print("MLModel : ", myYoloWorldModel)
//        print("Detector : ", detector)
//        print("Handler createdAt: ", createdAt)
        result(true)
    }

    public func detectImage(args: [String: Any],result: @escaping FlutterResult) async -> Void  {
        let imagePath = args["imagePath"] as! String
        let img_metadata = try! Data(contentsOf: URL(fileURLWithPath: imagePath))
        let requestHandler = VNImageRequestHandler(ciImage: CIImage(data: img_metadata)!, options: [:])
        let request = VNCoreMLRequest(model: detector!)
        
        let bounds: CGRect = await UIScreen.main.bounds
        screenSize = CGSize(width: bounds.width, height: bounds.height)
        let screenOrientation = await UIDevice.current.orientation

        var recognitions: [[String:Any]] = []
        do {
            try requestHandler.perform([request])
            if let results = request.results as? [VNRecognizedObjectObservation] {
                let width = self.screenSize?.width ?? 375
                let height = self.screenSize?.height ?? 816
                let ratio: CGFloat = (height / width) / (4.0 / 3.0)
                for i in 0...(results.count-1) {
                        let prediction = results[i]
                        
                        var rect = prediction.boundingBox
                        switch screenOrientation {
                        case .portraitUpsideDown:
                            rect = CGRect(x: 1.0 - rect.origin.x - rect.width,
                                          y: 1.0 - rect.origin.y - rect.height,
                                          width: rect.width,
                                          height: rect.height)
                        case .landscapeLeft:
                            rect = CGRect(x: rect.origin.y,
                                          y: 1.0 - rect.origin.x - rect.width,
                                          width: rect.height,
                                          height: rect.width)
                        case .landscapeRight:
                            rect = CGRect(x: 1.0 - rect.origin.y - rect.height,
                                          y: rect.origin.x,
                                          width: rect.height,
                                          height: rect.width)
                        case .unknown:
                            fallthrough
                        default: break
                        }
                        if ratio >= 1 { // iPhone ratio = 1.218
                            let offset = (1 - ratio) * (0.5 - rect.minX)
                            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: offset, y: -1)
                            rect = rect.applying(transform)
                            rect.size.width *= ratio
                        } else { // iPad ratio = 0.75
                            let offset = (ratio - 1) * (0.5 - rect.maxY)
                            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: offset - 1)
                            rect = rect.applying(transform)
                            rect.size.height /= ratio
                        }
                        rect = VNImageRectForNormalizedRect(rect, Int(width), Int(height))

                        let label = prediction.labels[0].identifier
                        let confidence = prediction.labels[0].confidence
                        recognitions.append(["label": label,
                                             "confidence": confidence,
                                             "x": rect.origin.x,
                                             "y": rect.origin.y,
                                             "width": rect.size.width,
                                             "height": rect.size.height])
                }
            }
        } catch {
            print(error)
        }
        result(recognitions)
        return
    }
}
