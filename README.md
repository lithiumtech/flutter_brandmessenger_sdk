# flutter_brandmessenger_sdk

Flutter plugin for Khoros BrandMessenger SDK
This is a flutter sdk wrapper around the native SDK libraries.

iOS: Requires access to https://github.com/lithiumtech/ios-brandmessenger-sdk-dist
flutter_brandmessenger_sdk v1.14.0 uses iOS SDK v1.14.0
Android: Requires access to https://github.com/lithiumtech/android-brandmessenger-sdk-dist
flutter_brandmessenger_sdk v1.14.0 uses Android SDK v1.14.0

Please contact Khoros Support and request access

## Installation

Add the following into `pubspec.yaml`

    flutter_brandmessenger_sdk:
      git:
        url: git@github.com:lithiumtech/flutter_brandmessenger_sdk.git
        ref: 1.14.0

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

To initialize BrandMessenger and connect to the correct company instance, you need the `companyKey` and `applicationId` and optional `widgetId`. Please contact Khoros Support to request these values for your company.

First, initialize with `companyKey` and `applicationId`

    App.bmsdk.initWithCompanyKeyAndApplicationId("<companyKey>", "<applicationId>");

or, initialize with `companyKey`, `applicationId` and `widgetId`

    App.bmsdk.initWithCompanyKeyApplicationIdWidgetId("<companyKey>", "<applicationId>", "<widgetId>");

If your application uses a non-default module-name, you also need to set AppModuleName on the SDK.

    App.bmsdk.setAppModuleName("<Custom App Module Name>");

You can also set widgetId separately

    App.bmsdk.setWidgetId("<widgetId>);

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

    App.bmsdk.logout().then((value) {
      // Dismiss is an async task, so you should watch for this Future to return before proceeding.
    });;

### Show

Once logged in, you can show the SDK's built-in chat screen.

    App.bmsdk.show().then((value) {
      // value is true if successful. An Exception object if failure
    });

If your Care instance is setup to use welcome-messaging, you can show chat and prompt the welcome message request.

    App.bmsdk.showWithWelcome().then((value) {
      // value is true if successful. An Exception object if failure
    });

Alternatively, you can prompt just for the welcome message without showing the chat-screen, for example when using your own custom built chat-screen.

    App.bmsdk.sendWelcomeMessageRequest();

### Dismiss

If needed, you can programmatically dismiss the chat screen.

    App.bmsdk.dismiss();

### isAllDisplayConditionsMet

You can check if the widget display conditions are currently met.
  
    App.bmsdk.isAllDisplayConditionsMet().then((value) {
      // process value
    });

### getAllDisplayConditions

You can get the display conditions to calculate if the criterias are met separately.

    App.bmsdk.getAllDisplayConditions().then((value) {
      // process value
    });

### isWidgetHashEnabled

Check if Widget Hash is enabled in the Agent Care console.

    App.bmsdk.isWidgetHashEnabled().then((value) {
      // process value
    });

### isDeviceGeoIPAllowed

Check if device's Geo IP is whitelisted.

    App.bmsdk.isDeviceGeoIPAllowed().then((value) {
      // process value
    });

### shouldThrottle

Check if chat needs to be throttled currently.

    App.bmsdk.shouldThrottle().then((value) {
      // process value
    });

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

### Certificate Pinning

Certificate pinning against Khoros Authentication and Messaging endpoints can be enabled.
(Available for APAC only in v0.2.0)

    App.bmsdk.enableDefaultCertificatePinning();

### Metadata

#### Updating user attributes

User attributes can by updated from the SDK by calling `updateUserAttributes`
It is highly recommended to call this after login.

    App.bmsdk.login(accessToken).then((value) {
      Map userAttributes = {};
      userAttributes["displayName"] = "Display Name";
      userAttributes["userImageLink"] = "Image Url";
      userAttributes["userStatus"] = "Status";
      userAttributes["metadata"] = {"additionalkey": "additionalvalue"};
      App.bmsdk.updateUserAttributes(userAttributes).then((value) {
        // update successful
      });
    });

#### Modifying message metadata

Metadata for each sent message can be modified by implementing `setBrandMessengerConversationDelegate` with a class with `BrandmessengerConversationDelegate`. This class will intercept before a message is sent, allowing the implementation to return a modified metadata Map to the SDK.

    class MetadataModifier with BrandmessengerConversationDelegate {
      static MetadataModifier instance = MetadataModifier();
      @override
      Map modifyMessageBeforeSend(Map metadata) {
        metadata["additionalkey"] = "additionalvalue";
        return metadata;
      }
    }
    ...
    MyApp.bmsdk
        .setBrandMessengerConversationDelegate(MetadataModifier.instance);