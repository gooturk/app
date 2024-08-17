import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let gooturkChannel = FlutterMethodChannel(name: "gooturk_native", binaryMessenger: controller.binaryMessenger)
    let methodHandler = GooturkMethodCallHandler()
    gooturkChannel.setMethodCallHandler(methodHandler.handle)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

