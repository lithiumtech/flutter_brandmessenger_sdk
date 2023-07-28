import 'package:flutter_brandmessenger_sdk/flutter_brandmessenger_sdk_method_channel.dart';

class FlutterBrandmessengerSdk {
  static MethodChannelFlutterBrandmessengerSdk get _methodChannel =>
      MethodChannelFlutterBrandmessengerSdk();

  Future<String?> getPlatformVersion() {
    return _methodChannel.getPlatformVersion();
  }

  Future<dynamic> initWithCompanyKeyApplicationIdWidgetId(
      companyKey, applicationId, widgetId) async {
    return _methodChannel.initWithCompanyKeyApplicationIdWidgetId(
        companyKey, applicationId, widgetId);
  }

  Future<dynamic> initWithCompanyKeyAndApplicationId(
      companyKey, applicationId) async {
    return initWithCompanyKeyApplicationIdWidgetId(
        companyKey, applicationId, null);
  }

  Future<dynamic> setBaseURL(baseUrl) async {
    return _methodChannel.setBaseURL(baseUrl);
  }

  Future<dynamic> setAuthenticationHandlerUrl(authHandlerUrl) async {
    return _methodChannel.setAuthenticationHandlerUrl(authHandlerUrl);
  }

  void setConfigurationUrl(configurationUrl) async {
    _methodChannel.setConfigurationUrl(configurationUrl);
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

  Future<dynamic> dismiss() async {
    return _methodChannel.dismiss();
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

  Future<dynamic> showWithWelcome() async {
    return _methodChannel.showWithWelcome();
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

  Future<dynamic> logout() {
    return _methodChannel.logout();
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

  Future<dynamic> updateUserAttributes(Map userAttributes) async {
    return _methodChannel.updateUserAttributes(userAttributes);
  }

  void setWidgetId(String widgetId) async {
    _methodChannel.setWidgetId(widgetId);
  }

  Future<dynamic> getAllDisplayConditions() {
    return _methodChannel.getAllDisplayConditions();
  }

  Future<dynamic> isWidgetHashEnabled() {
    return _methodChannel.isWidgetHashEnabled();
  }

  Future<dynamic> isAllDisplayConditionsMet() {
    return _methodChannel.isAllDisplayConditionsMet();
  }

  Future<dynamic> isDeviceGeoIPAllowed() {
    return _methodChannel.isDeviceGeoIPAllowed();
  }

  Future<dynamic> shouldThrottle() {
    return _methodChannel.shouldThrottle();
  }
}
