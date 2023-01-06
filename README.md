# flutter_brandmessenger_sdk

Flutter plugin for Khoros BrandMessenger SDK
This is a flutter sdk wrapper around the native SDK libraries.

iOS: Requires access to https://github.com/lithiumtech/ios-brandmessenger-sdk-dist
flutter_brandmessenger_sdk v0.2.0 uses iOS SDK v1.13.0
Android: Requires access to https://github.com/lithiumtech/android-brandmessenger-sdk-dist
flutter_brandmessenger_sdk v0.2.0 uses Android SDK v1.13.0

Please contact Khoros Support and request access

## Installation

Add the following into `pubspec.yaml`

    flutter_brandmessenger_sdk:
      git:
        url: git@github.com:lithiumtech/flutter_brandmessenger_sdk.git
        ref: main

Run following command to download the sdk

    flutter pub get

Run following in `/ios` directory to download iOS framework

pod install

## Usage

The SDK methods can be access via `FlutterBrandmessengerSdk` class object.
For example, create an instance in your `App` class

    class App extends StatelessWidget {
    const MyApp({super.key});
      static FlutterBrandmessengerSdk bmsdk = FlutterBrandmessengerSdk();
      ...

}
And call sdk methods, eg:

    App.bmsdk.show();

### Initialization

To initialize BrandMessenger and connect to the correct company instance, you need the `companyKey` and `applicationId`. Please contact Khoros Support to request these values for your company.

First, initialize with `companyKey` and `applicationId`

    App.bmsdk.initWithCompanyKeyAndApplicationId("<companyKey>", "<applicationId>");

If your application uses a non-default module-name, you also need to set AppModuleName on the SDK.

    App.bmsdk.setAppModuleName("<Custom App Module Name>");

#### Region

The SDK needs to use the correct region for your Care instance. Default region is APAC, you can use `setRegion` to switch if your Care instance region is elsewhere. Current available options are `APAC` and `US`.

    App.bmsdk.setRegion('US');

Or you can switch the base messaging and authentication endpoints to their respective region endpoints directly (instead of using `setRegion`). Eg:

    App.bmsdk.setBaseURL("https://brandmessenger.khoros.com");
    App.bmsdk.setAuthenticationHandlerUrl("https://messaging-auth.khoros.com");

### Authentication

The SDK offers various ways to login depending on how the integration to customer login portal has been set up.

#### Login Using IDP Token

    App.bmsdk.login(accessToken).then((result) {
      // Login success
    }).onError((error, stackTrace) {
    // Login error
    });

#### Login Using JWT Token

    App.bmsdk.loginWithJWT(jwt, userid).then((result) {
      // Login success
    }).onError((error, stackTrace) {
    // Login error
    });

#### Login as Anonymous User

    App.bmsdk.loginAnonymousUser().then((result) {
      // Login success
    }).onError((error, stackTrace) {
    // Login error
    });

#### Check Authenticated Status

    App.bmsdk.isAuthenticated().then((value) => {
      if (value == true) {
        // logged in
      } else {
        // not logged in or expired
      }
    });

#### Logout

    App.bmsdk.logout();

### Show

Once logged in, you can show the SDK's built-in chat screen.

    App.bmsdk.show();

If your Care instance is setup to use welcome-messaging, you can show chat and prompt the welcome message request.

    App.bmsdk.showWithWelcome();

Alternatively, you can prompt just for the welcome message without showing the chat-screen, for example when using your own custom built chat-screen.

    App.bmsdk.sendWelcomeMessageRequest();

### Unread Count

In order to retrieve unread messages count, you need to implement a class with `BrandmessengerNativeCallbackDelegate`

    class UnreadCounter with BrandmessengerNativeCallbackDelegate {
    static UnreadCounter instance = UnreadCounter();
    @override
    void receiveUnreadCount(int unreadCount) {
      // TODO: implement receiveUnreadCount
    }

}

and set it to `setBrandMessengerNativeCallbackDelegate`.

App.bmsdk.setBrandMessengerNativeCallbackDelegate(UnreadCounter.instance);
Once that is done, you can use the following two ways to retrieve unread messages count:

#### Get Unread Count

This will manually check the latest unread count from the API and call `void receiveUnreadCount(int unreadCount)`.

    App.bmsdk.getUnreadCount();

#### Monitor Unread Count

This will start monitoring for local changes to the unread count and call `void receiveUnreadCount(int unreadCount)`. For example, when the app received a push notification for new message received, but is not on the chat screen, the local unread messages count will increase by one.

    App.bmsdk.monitorUnreadCount();

### Refresh message on chat-open

The SDK's default behavior is to fetch new message only when it knows there are new messages, after receiving push notifications or socket messages.
This behavior can be switched to fetch latest message every time the chat-screen is opened.

    App.bmsdk.fetchNewMessagesOnChatOpen(true);

### Use persistent storage

The SDK's default behavior is to use a temporary in-memory database to store conversation history.
This behavior can be switched to use persistent on-disk database.

    App.bmsdk.setUsePersistentMessagesStorage(true);

## Push Notifications

BrandMessenger SDK supports push notifications.

#### Notes for Android

For Android, you need to get the firebase token and register it with the BrandMessenger SDK after successful login. Eg:

    App.bmsdk.login(accessToken).then((result) {
      App.bmsdk.registerDeviceForPushNotification().then((result) {
      });
    });

On iOS, `registerDeviceForPushNotification` will return `Future.error()`.
