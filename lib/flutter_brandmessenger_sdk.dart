
import 'flutter_brandmessenger_sdk_platform_interface.dart';

class FlutterBrandmessengerSdk {
  Future<String?> getPlatformVersion() {
    return FlutterBrandmessengerSdkPlatform.instance.getPlatformVersion();
  }
}
