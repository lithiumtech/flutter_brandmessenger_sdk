import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_brandmessenger_sdk_method_channel.dart';

abstract class FlutterBrandmessengerSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterBrandmessengerSdkPlatform.
  FlutterBrandmessengerSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBrandmessengerSdkPlatform _instance = MethodChannelFlutterBrandmessengerSdk();

  /// The default instance of [FlutterBrandmessengerSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBrandmessengerSdk].
  static FlutterBrandmessengerSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBrandmessengerSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterBrandmessengerSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
