import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_brandmessenger_sdk_platform_interface.dart';
import 'dart:io' show Platform;

mixin BrandmessengerNativeCallbackDelegate {
  void receiveUnreadCount(int unreadCount);
}

mixin BrandmessengerConversationDelegate {
  Map modifyMessageBeforeSend(Map metadata);
}

/// An implementation of [FlutterBrandmessengerSdkPlatform] that uses method channels.
class MethodChannelFlutterBrandmessengerSdk
    extends FlutterBrandmessengerSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_brandmessenger_sdk');

  MethodChannelFlutterBrandmessengerSdk() {
    methodChannel.setMethodCallHandler(callbackDelegateHandler);
  }

  static BrandmessengerNativeCallbackDelegate? nativeDelegate;
  static BrandmessengerConversationDelegate? conversationDelegate;
  Future<Object?> callbackDelegateHandler(MethodCall call) async {
    switch (call.method) {
      case "receiveUnreadCount":
        {
          final unreadCount = call.arguments as int;
          nativeDelegate?.receiveUnreadCount(unreadCount);
          break;
        }
      case "modifyMessageBeforeSend":
        {
          final metadata = call.arguments as Map;
          Map? modifiedMetadata = metadata;
          if (conversationDelegate != null) {
            modifiedMetadata =
                conversationDelegate?.modifyMessageBeforeSend(metadata);
          }
          return modifiedMetadata;
        }
      default:
        print('TestFairy: Ignoring invoke from native.');
    }
    return null;
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<dynamic> initWithCompanyKeyApplicationIdWidgetId(
      companyKey, applicationId, widgetId) async {
    return await methodChannel.invokeMethod(
        'initWithCompanyKeyApplicationIdWidgetId', {
      "companyKey": companyKey,
      "applicationId": applicationId,
      "widgetId": widgetId
    });
  }

  Future<dynamic> setBaseURL(baseUrl) async {
    return await methodChannel.invokeMethod('setBaseURL', baseUrl);
  }

  Future<dynamic> setAuthenticationHandlerUrl(authHandlerUrl) async {
    return await methodChannel.invokeMethod(
        'setAuthenticationHandlerUrl', authHandlerUrl);
  }

  void setConfigurationUrl(configurationUrl) async {
    await methodChannel.invokeMethod('setConfigurationUrl', configurationUrl);
  }

  Future<dynamic> setAppModuleName(moduleName) async {
    return await methodChannel.invokeMethod('setAppModuleName', moduleName);
  }

  Future<dynamic> login(String accessToken) async {
    return await methodChannel.invokeMethod('login', accessToken);
  }

  Future<dynamic> loginWithJWT(String jwt, String userId) async {
    return await methodChannel.invokeMethod('loginWithJWT', [jwt, userId]);
  }

  Future<dynamic> loginAnonymousUser() async {
    return await methodChannel.invokeMethod('loginAnonymousUser');
  }

  Future<dynamic> show() async {
    return await methodChannel.invokeMethod('show');
  }

  Future<dynamic> dismiss() async {
    return await methodChannel.invokeMethod('dismiss');
  }

  Future<bool?> isAuthenticated() async {
    final isAuthenticated =
        await methodChannel.invokeMethod<bool>('isAuthenticated');
    return isAuthenticated;
  }

  Future<String?> getUserId() async {
    return await methodChannel.invokeMethod('getUserId');
  }

  void getUnreadCount() {
    methodChannel.invokeMethod('getUnreadCount');
  }

  void monitorUnreadCount() {
    methodChannel.invokeMethod('monitorUnreadCount');
  }

  Future<dynamic> showWithWelcome() async {
    return await methodChannel.invokeMethod("showWithWelcome");
  }

  void sendWelcomeMessageRequest() {
    methodChannel.invokeMethod('sendWelcomeMessageRequest');
  }

  void fetchNewMessagesOnChatOpen(bool fetchOnOpen) {
    methodChannel.invokeMethod('fetchNewMessagesOnChatOpen', fetchOnOpen);
  }

  void setUsePersistentMessagesStorage(bool usePersistentStorage) {
    methodChannel.invokeMethod(
        'setUsePersistentMessagesStorage', usePersistentStorage);
  }

  Future<dynamic> logout() {
    return methodChannel.invokeMethod('logout');
  }

  void setBrandMessengerNativeCallbackDelegate(
      BrandmessengerNativeCallbackDelegate delegate) {
    nativeDelegate = delegate;
  }

  void setBrandMessengerConversationDelegate(
      BrandmessengerConversationDelegate? delegate) {
    conversationDelegate = delegate;
  }

  Future<dynamic> registerDeviceForPushNotification() async {
    if (Platform.isAndroid) {
      return await methodChannel
          .invokeMethod('registerDeviceForPushNotification');
    }
    return Future.error(
        'BrandMessenger: registerDeviceForPushNotification called on non-android platform');
  }

  void setRegion(String region) {
    methodChannel.invokeMethod('setRegion', region);
  }

  void enableDefaultCertificatePinning() {
    methodChannel.invokeMethod('enableDefaultCertificatePinning');
  }

  Future<dynamic> updateUserAttributes(Map userAttributes) async {
    return await methodChannel.invokeMethod(
        "updateUserAttributes", userAttributes);
  }

  void setWidgetId(String widgetId) async {
    methodChannel.invokeMethod("setWidgetId", widgetId);
  }

  Future<dynamic> getAllDisplayConditions() async {
    return await methodChannel.invokeMethod("getAllDisplayConditions");
  }

  Future<dynamic> isWidgetHashEnabled() async {
    return await methodChannel.invokeMethod("isWidgetHashEnabled");
  }

  Future<dynamic> isAllDisplayConditionsMet() async {
    return await methodChannel.invokeMethod("isAllDisplayConditionsMet");
  }

  Future<dynamic> isDeviceGeoIPAllowed() async {
    return await methodChannel.invokeMethod("isDeviceGeoIPAllowed");
  }

  Future<dynamic> shouldThrottle() async {
    return await methodChannel.invokeMethod("shouldThrottle");
  }
}
