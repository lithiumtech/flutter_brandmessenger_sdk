import 'package:flutter_brandmessenger_sdk/flutter_brandmessenger_sdk_method_channel.dart';

class FlutterBrandmessengerSdk {
  static MethodChannelFlutterBrandmessengerSdk get _methodChannel =>
      MethodChannelFlutterBrandmessengerSdk();

  Future<String?> getPlatformVersion() {
    return _methodChannel.getPlatformVersion();
  }

  Future<dynamic> initWithCompanyKeyAndApplicationId(
      companyKey, applicationId) async {
    return _methodChannel.initWithCompanyKeyAndApplicationId(
        companyKey, applicationId);
  }

  Future<dynamic> setBaseURL(baseUrl) async {
    return _methodChannel.setBaseURL(baseUrl);
  }

  Future<dynamic> setAuthenticationHandlerUrl(authHandlerUrl) async {
    return _methodChannel.setAuthenticationHandlerUrl(authHandlerUrl);
  }

  Future<dynamic> setAppModuleName(moduleName) async {
    return _methodChannel.setAppModuleName(moduleName);
  }

  Future<dynamic> login(String user) async {
    return _methodChannel.login(user);
  }

  Future<dynamic> loginWithJWT(String jwt, String userId) async {
    return _methodChannel.loginWithJWT(jwt, userId);
  }

  Future<dynamic> loginAnonymousUser() async {
    return _methodChannel.loginAnonymousUser();
  }

  Future<dynamic> show() async {
    return _methodChannel.show();
  }

  Future<bool?> isAuthenticated() async {
    return _methodChannel.isAuthenticated();
  }

  Future<String?> getUserId() async {
    return _methodChannel.getUserId();
  }

  void getUnreadCount() {
    _methodChannel.getUnreadCount();
  }

  void monitorUnreadCount() {
    _methodChannel.monitorUnreadCount();
  }

  void showWithWelcome() {
    _methodChannel.showWithWelcome();
  }

  void sendWelcomeMessageRequest() {
    _methodChannel.sendWelcomeMessageRequest();
  }

  void fetchNewMessagesOnChatOpen(bool fetchOnOpen) {
    _methodChannel.fetchNewMessagesOnChatOpen(fetchOnOpen);
  }

  void setUsePersistentMessagesStorage(bool usePersistentStorage) {
    _methodChannel.setUsePersistentMessagesStorage(usePersistentStorage);
  }

  void logout() {
    _methodChannel.logout();
  }

  void setBrandMessengerNativeCallbackDelegate(
      final BrandmessengerNativeCallbackDelegate delegate) {
    _methodChannel.setBrandMessengerNativeCallbackDelegate(delegate);
  }

  void setBrandMessengerConversationDelegate(
      BrandmessengerConversationDelegate? delegate) {
    _methodChannel.setBrandMessengerConversationDelegate(delegate);
  }

// Android only. iOS will return Future.error
  Future<dynamic> registerDeviceForPushNotification() async {
    return _methodChannel.registerDeviceForPushNotification();
  }

  void setRegion(String region) {
    _methodChannel.setRegion(region);
  }

  void enableDefaultCertificatePinning() {
    _methodChannel.enableDefaultCertificatePinning();
  }
}
