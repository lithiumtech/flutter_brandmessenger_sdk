import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_brandmessenger_sdk_platform_interface.dart';

/// An implementation of [FlutterBrandmessengerSdkPlatform] that uses method channels.
class MethodChannelFlutterBrandmessengerSdk
    extends FlutterBrandmessengerSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_brandmessenger_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<dynamic> initWithCompanyKeyAndApplicationId(
      companyKey, applicationId) async {
    return await methodChannel.invokeMethod(
        'initWithCompanyKeyAndApplicationId', [companyKey, applicationId]);
  }

  Future<dynamic> setBaseURL(baseUrl) async {
    return await methodChannel.invokeMethod('setBaseURL', baseUrl);
  }

  Future<dynamic> setAuthenticationHandlerUrl(authHandlerUrl) async {
    return await methodChannel.invokeMethod(
        'setAuthenticationHandlerUrl', authHandlerUrl);
  }

  Future<dynamic> login(dynamic user) async {
    return await methodChannel.invokeMethod('login', user);
  }

  Future<dynamic> show() async {
    return await methodChannel.invokeMethod('show');
  }
}
