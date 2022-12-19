import Flutter
import UIKit
import BrandMessengerUI
import BrandMessengerCore

public class SwiftFlutterBrandmessengerSdkPlugin: NSObject, FlutterPlugin {
    static var _channel: FlutterMethodChannel? = nil
    
    // MARK: FlutterPlugin
    public static func register(with registrar: FlutterPluginRegistrar) {
        _channel = FlutterMethodChannel(name: "flutter_brandmessenger_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterBrandmessengerSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: _channel!)
        registrar.addApplicationDelegate(instance)
    }
        
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "fetchNewMessagesOnChatOpen") {
           if let fetchOnOpen = call.arguments as? Bool {
               KBMUserDefaultsHandler.setFetchNewOnChatOpen(fetchOnOpen)
           }
        } else if (call.method == "getUnreadCount") {
            BrandMessengerManager.getTotalUnreadCount { count, error in
                if let channel = SwiftFlutterBrandmessengerSdkPlugin._channel {
                    channel.invokeMethod("receiveUnreadCount", arguments: count)
                }
            }
            result(KBMUserDefaultsHandler.getUserId())
        } else if (call.method == "getUserId") {
            result(KBMUserDefaultsHandler.getUserId())
        } else if (call.method == "initWithCompanyKeyAndApplicationId") {
            BrandMessengerManager.doNotAutosubscribeOnLaunch(false)
            if let args = call.arguments as? [NSString], args.count == 2 {
                BrandMessengerManager(companyKey: args[0], applicationKey: args[1])
            }
        } else if (call.method == "isAuthenticated") {
            BrandMessengerManager.isAuthenticated { response in
                result(NSNumber(value:response))
            }
        } else if (call.method == "login") {
            if let userId = call.arguments as? String {
                BrandMessengerManager.login(userId) { response, error in
                    result("BrandMessenger: Login " + (error != nil ? "Error" : "Success"))
                }
            }
        } else if (call.method == "loginAnonymousUser") {
            BrandMessengerManager.loginAnonymousUser { response, error in
                result("BrandMessenger: Login " + (error != nil ? "Error" : "Success"))
            }
        } else if (call.method == "loginWithJWT") {
            if let args = call.arguments as? [String], args.count == 2 {
                BrandMessengerManager.loginWithJWT(args[0], userId: args[1]) { response, error in
                    result("BrandMessenger: Login " + (error != nil ? "Error" : "Success"))
                }
            }
        } else if (call.method == "logout") {
            BrandMessengerManager.logoutUser { completed in
                result(completed)
            }
            
        } else if (call.method == "sendWelcomeMessageRequest") {
            BrandMessengerManager.sendWelcomeMessageRequest { response, error in
                print("sendWelcomeMessageRequest Response: \(response) \(error)")
            }
        } else if (call.method == "setAppModuleName") {
            if let arg = call.arguments as? String {
                KBMUserDefaultsHandler.setAppModuleName(arg)
            }
        } else if (call.method == "setAuthenticationHandlerUrl") {
            if let arg = call.arguments as? String {
                KBMUserDefaultsHandler.setCustomAuthHandlerUrl(arg)
            }
        } else if (call.method == "setBaseURL") {
            if let arg = call.arguments as? String {
                KBMUserDefaultsHandler.setBASEURL(arg)
            }
        } else if (call.method == "setRegion") {
            if let arg = call.arguments as? String {
                BrandMessengerManager.setRegion(arg)
            }
        } else if (call.method == "setUsePersistentMessagesStorage") {
            if let usePersistentStorage = call.arguments as? Bool {
                KBMUserDefaultsHandler.setUsePersistentMessagesStorage(usePersistentStorage)
            }
        } else if (call.method == "show") {
            BrandMessengerManager.show()
        } else if (call.method == "showWithWelcome") {
            BrandMessengerManager.showWithWelcome()
        } else {
            result("iOS " + UIDevice.current.systemVersion)
        }
    }
    
    // MARK: AuthenticationDelegate
    // KBMAuthenticationDelegate is a synchronous action that required a string return value.
    class AuthenticationDelegate: NSObject, KBMAuthenticationDelegate {
        func onRefreshFail(_ completion: @escaping (String) -> Void) {
            if let channel = _channel {
                completion("")
            }
        }
    }
    
    public static func setAuthenticationDelegate() {
        BrandMessengerManager.setAuthenticationDelegate(AuthenticationDelegate())
    }
    
    // MARK: KBMConversationViewControllerDelegate
    // MessageActionDelegate is a synchronous action that required a boolean return value.
    class MessageActionDelegate: NSObject, KBMConversationViewControllerDelegate {
        func handleMessageAction(index: Int?, title: String?, message: KBMMessageViewModel?, cardTemplate: CardTemplate?, listAction: ListTemplate.Action?, isButtonDisabled: Bool?) -> Bool {
            return true
        }
    }
    
    public static func setMessageActionDelegate() {
        BrandMessengerManager.setMessageActionDelegate(MessageActionDelegate())
    }
    
    // MARK: Unread count monitor
    @objc func onUnreadCount(notification: NSNotification?) {
        if let channel = SwiftFlutterBrandmessengerSdkPlugin._channel, let obj = notification?.object as? NSDictionary, let count = obj.value(forKey: "unreadCount")  {
            channel.invokeMethod("receiveUnreadCount", arguments: count)
        }
    }
    
    // MARK: FlutterPluginAppLifeCycleDelegate
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { grant, error in
            if error == nil {
                if grant {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    // User didn't grant permission
                }
            } else {
                print("error: ",error)
            }
        }
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        debugPrint("applicationDidBecomeActive")
        NotificationCenter.default.addObserver(self, selector: #selector(onUnreadCount(notification:)), name: NSNotification.Name("BRAND_MESSENGER_UNREAD_COUNT"), object: nil)
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        debugPrint("applicationWillTerminate")
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        debugPrint("applicationWillResignActive")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("BRAND_MESSENGER_UNREAD_COUNT"), object: nil)
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("applicationDidEnterBackground")
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }
    
    // MARK: APNS
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BrandMessengerManager.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        if KBMPushNotificationService().isBrandMessengerChatNotification(userInfo) {
            BrandMessengerManager.application(application, didReceiveRemoteNotification: userInfo) { result in
                completionHandler(result)
            }
            return true
        }
        return false
    }
}