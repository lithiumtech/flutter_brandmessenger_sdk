# Flutter BrandMessenger SDK - Build Runbook

## Prerequisites

| Requirement | Version | Purpose |
|-------------|---------|----------|
| **Flutter SDK** | ≥ 3.0.0 | Core framework |
| **Dart** | ≥ 3.0.0 | Included with Flutter |
| **Android SDK** | compileSdk 34, minSdk 21 | Android builds |
| **Java JDK** | 8+ | Android compilation |
| **Xcode** | ≥ 14.0 | iOS builds (iOS 12+) |
| **CocoaPods** | Latest | iOS dependency management |

### Environment Variables
- `JAVA_HOME` - Path to JDK installation
- `FLUTTER_ROOT` - Path to Flutter SDK

## Build Commands

### Development Setup
```bash
# Install dependencies
flutter pub get

# iOS setup (macOS only)
cd ios && pod install
```

### Code Quality
```bash
# Static analysis
flutter analyze

# Format code
dart format .

# Run tests
flutter test
```

### Plugin Validation
```bash
# Dry run publish
flutter pub publish --dry-run

# Validate plugin structure
flutter pub deps
```

## Dependencies

### Android
- **BrandMessenger Core**: `com.khoros.android-brandmessenger-sdk:brandmessengercore:1.16.4`
- **BrandMessenger UI**: `com.khoros.android-brandmessenger-sdk:brandmessengerui:1.16.4`
- **Source**: JitPack repository

### iOS
- **BrandMessenger**: `~> 1.16.4`
- **Source**: Private CocoaPods spec
- **Frameworks**: UIKit, Security, Foundation, Network, MobileCoreServices

## Build Outputs

| Component | Output | Location |
|-----------|--------|----------|
| **Plugin Package** | `.tar.gz` | pub.dev |
| **Android Library** | `.aar` | Gradle cache |
| **iOS Framework** | `.xcframework` | CocoaPods cache |

## Version Management

Update version in these files:
1. `pubspec.yaml` - Main package version
2. `ios/flutter_brandmessenger_sdk.podspec` - iOS podspec version
3. `android/build.gradle` - Android library version

## Publishing

```bash
# Validate before publishing
flutter pub publish --dry-run

# Publish to pub.dev
flutter pub publish
```

## Troubleshooting

- **iOS build fails**: Run `pod install` in ios directory
- **Android build fails**: Check JAVA_HOME and SDK paths
- **Dependency issues**: Clear caches with `flutter clean`
