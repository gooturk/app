import Foundation
import Vision
import CoreML

class GooturkMethodCallHandler{
    private var myYoloWorldModel: MLModel?
    private var detector: VNCoreMLModel?
    private var screenSize: CGSize?
    private var screenOrientation: UIDeviceOrientation?
    private var createdAt: Date?
    private var configml: MLModelConfiguration?
    private var mlfeature: ThresholdProvider?
    
    public init() {
        createdAt = Date()
        configml = MLModelConfiguration()
        configml!.computeUnits = .all
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
                mlfeature = ThresholdProvider(iouThreshold: 0.4, confidenceThreshold: 0.05)
                detector = try VNCoreMLModel(for: myYoloWorldModel!)
                detector!.featureProvider = mlfeature
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
        let img = CIImage(data: img_metadata)
        let requestHandler = VNImageRequestHandler(ciImage: img!, options: [:])
        let request = VNCoreMLRequest(model: detector!)
        request.imageCropAndScaleOption = .scaleFill
        
        let bounds: CGRect = await UIScreen.main.bounds
        screenSize = CGSize(width: bounds.width, height: bounds.height)
        let screenOrientation = await UIDevice.current.orientation
        let w = img?.extent.width
        let h = img?.extent.height

        var recognitions: [[String:Any]] = []
        do {
            try requestHandler.perform([request])
            if let results = request.results as? [VNRecognizedObjectObservation] {
                for i in 0...(results.count-1) {
                        let prediction = results[i]
                        var rect = prediction.boundingBox
                    print("\(i+1): origin\(rect.origin.x), \(rect.origin.y) / \(rect.width), \(rect.height)  ")
                        let label = prediction.labels[0].identifier
                        let confidence = prediction.labels[0].confidence
                        recognitions.append(["label": label,
                                             "confidence": confidence,
                                             "x": rect.origin.x * w!,
                                             "y": (1 - rect.origin.y) * h!,
                                             "width": rect.size.width * w!,
                                             "height": rect.size.height * h!])
                }
            }
        } catch {
            print(error)
        }
        result(recognitions)
        return
    }
}

public class ThresholdProvider: MLFeatureProvider {
    var values = [
        "iouThreshold": MLFeatureValue(double: 0.4),
        "confidenceThreshold": MLFeatureValue(double: 0.01)
    ]

    public var featureNames: Set<String> {
        return Set(values.keys)
    }

    init(iouThreshold: Double = 0.4, confidenceThreshold: Double = 0.01) {
        self.values["iouThreshold"] = MLFeatureValue(double: iouThreshold)
        self.values["confidenceThreshold"] = MLFeatureValue(double: confidenceThreshold)
    }

    public func featureValue(for featureName: String) -> MLFeatureValue? {
        return values[featureName]
    }
}

