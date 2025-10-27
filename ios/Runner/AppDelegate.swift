import Flutter
import UIKit
import Photos

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let photoPermissionChannel = "photoPermissionChannel"  // Define channel name


  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)


    // Access the FlutterViewController to create the MethodChannel
    guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("RootViewController is not of type FlutterViewController")
    }
    
    // Initialize the method channel
    let permissionChannel = FlutterMethodChannel(name: photoPermissionChannel, binaryMessenger: controller.binaryMessenger)

    // Handle method calls
    permissionChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "requestPhotoPermission" {
        self?.requestPhotoPermission(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    // Photo permission request
  private func requestPhotoPermission(result: @escaping FlutterResult) {
    PHPhotoLibrary.requestAuthorization { status in
      switch status {
      case .authorized:
        result("Photo access granted")
      case .denied, .restricted:
        result("Photo access denied")
      case .notDetermined:
        result("Photo access not determined")
      @unknown default:
        result(FlutterError(code: "UNKNOWN", message: "Unknown permission status", details: nil))
      }
    }
  }
}
