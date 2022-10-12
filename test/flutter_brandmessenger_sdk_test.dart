import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_brandmessenger_sdk/flutter_brandmessenger_sdk.dart';
import 'package:flutter_brandmessenger_sdk/flutter_brandmessenger_sdk_platform_interface.dart';
import 'package:flutter_brandmessenger_sdk/flutter_brandmessenger_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBrandmessengerSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBrandmessengerSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterBrandmessengerSdkPlatform initialPlatform = FlutterBrandmessengerSdkPlatform.instance;

  test('$MethodChannelFlutterBrandmessengerSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBrandmessengerSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterBrandmessengerSdk flutterBrandmessengerSdkPlugin = FlutterBrandmessengerSdk();
    MockFlutterBrandmessengerSdkPlatform fakePlatform = MockFlutterBrandmessengerSdkPlatform();
    FlutterBrandmessengerSdkPlatform.instance = fakePlatform;

    expect(await flutterBrandmessengerSdkPlugin.getPlatformVersion(), '42');
  });
}
