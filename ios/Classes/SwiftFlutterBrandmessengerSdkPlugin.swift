import Flutter
import UIKit
import BrandMessengerUI
import BrandMessengerCore

public class SwiftFlutterBrandmessengerSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_brandmessenger_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterBrandmessengerSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
    if (call.method == "initWithCompanyKeyAndApplicationId") {
        BrandMessengerManager.doNotAutosubscribeOnLaunch(false)
        if let args = call.arguments as? [NSString], args.count == 2 {
            BrandMessengerManager(companyKey: args[0], applicationKey: args[1])
        }
    } else if (call.method == "setBaseURL") {
        if let arg = call.arguments as? String {
            KBMUserDefaultsHandler.setBASEURL(arg)
        }
    } else if (call.method == "setAuthenticationHandlerUrl") {
        if let arg = call.arguments as? String {
            KBMUserDefaultsHandler.setCustomAuthHandlerUrl(arg)
        }
    } else if (call.method == "login") {
        BrandMessengerManager.login("0340ddbb-e24a-4a3d-a1f9-6dcc4467be69") { response, error in
            print("LOGIN COMPLETE \(response)")
        }
    } else if (call.method == "show") {
        BrandMessengerManager.show()
    }
  }
}
