#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_brandmessenger_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_brandmessenger_sdk'
  s.version          = '1.14.0'
  s.summary          = 'Flutter plugin for Khoros BrandMessenger SDK.'
  s.description      = <<-DESC
Flutter plugin for Khoros BrandMessenger SDK
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Khoros' => 'support@khoros.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.prepare_command = 'rm -rf ./ios-brandmessenger-sdk-dist && git clone --depth=1 --branch=1.14.0 https://github.com/lithiumtech/ios-brandmessenger-sdk-dist.git && rm -rf ./ios-brandmessenger-sdk-dist/.git'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.ios.vendored_frameworks = 'ios-brandmessenger-sdk-dist/BrandMessengerUI.xcframework', 'ios-brandmessenger-sdk-dist/BrandMessengerCore.xcframework','ios-brandmessenger-sdk-dist/RichMessageKit.xcframework', 'ios-brandmessenger-sdk-dist/Kingfisher.xcframework', 'ios-brandmessenger-sdk-dist/ISEmojiView.xcframework'
  s.ios.frameworks = ["UIKit", "Security", "Foundation", "Network", "MobileCoreServices", "SystemConfiguration", "CoreFoundation"]
  s.swift_version = '5.0'
end
