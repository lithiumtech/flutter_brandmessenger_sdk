package com.brandmessenger.flutter_brandmessenger_sdk

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.annotation.NonNull
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.brandmessenger.core.BrandMessenger
import com.brandmessenger.core.api.BrandMessengerConstants
import com.brandmessenger.core.api.account.register.RegistrationResponse
import com.brandmessenger.core.api.account.user.BrandMessengerUserPreference
import com.brandmessenger.core.api.account.user.UserService
import com.brandmessenger.core.api.authentication.KBMAuthenticationDelegate
import com.brandmessenger.core.api.authentication.KBMAuthenticationDelegateCallback
import com.brandmessenger.core.api.conversation.KBMConversationDelegate
import com.brandmessenger.core.api.conversation.Message
import com.brandmessenger.core.api.conversation.database.MessageDatabaseService
import com.brandmessenger.core.listeners.KBMLoginHandler
import com.brandmessenger.core.listeners.KBMLogoutHandler
import com.brandmessenger.core.listeners.KBMPushNotificationHandler
import com.brandmessenger.core.ui.BrandMessengerManager
import com.brandmessenger.core.ui.conversation.richmessaging.KBMMessageActionDelegate
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.Executors
import java.util.concurrent.Semaphore

/** FlutterBrandmessengerSdkPlugin */
class FlutterBrandmessengerSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private var activity: Activity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_brandmessenger_sdk")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (activity == null) {
      result.error("NoActivity", "NoActivity", "NoActivity")
    }
    if (call.method == "enableDefaultCertificatePinning") {
      BrandMessengerManager.enableDefaultCertificatePinning(activity)
    } else if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "fetchNewMessagesOnChatOpen") {
      val fetchOnOpen = call.arguments as? Boolean
      BrandMessengerUserPreference.getInstance(activity).fetchNewOnFragmentOpen = fetchOnOpen!!
    } else if (call.method == "getUnreadCount") {
      Thread {
        val count = BrandMessengerManager.getTotalUnreadCount(activity)
        activity!!.runOnUiThread {
          channel.invokeMethod("receiveUnreadCount", count)
        }
      }.start()
    } else if (call.method == "getUserId") {
      val userId = BrandMessengerManager.getDefaultUserId(activity)
      result.success(userId)
    } else if (call.method == "initWithCompanyKeyAndApplicationId") {
      val args = call.arguments as? ArrayList<*>
      if (args != null && args.size == 2) {
        BrandMessengerManager.init(activity!!, args[0] as String, args[1] as String)
      }
    } else if (call.method == "isAuthenticated") {
      val isAuthenticated = BrandMessengerManager.isAuthenticated(activity, false)
      result.success(isAuthenticated)
    } else if (call.method == "login") {
      val args = call.arguments as? String
      BrandMessengerManager.login(activity, args, object : KBMLoginHandler {
        override fun onSuccess(p0: RegistrationResponse, p1: Context?) {
          result.success(p0.toString());
        }

        override fun onFailure(p0: RegistrationResponse?, p1: java.lang.Exception?) {
          result.error("LoginError", "LoginError", p0.toString())
        }
      })
    } else if (call.method == "loginAnonymousUser") {
      BrandMessengerManager.loginAnonymousUser(activity, object: KBMLoginHandler {
        override fun onSuccess(p0: RegistrationResponse, p1: Context?) {
          result.success(p0.toString());
        }

        override fun onFailure(p0: RegistrationResponse?, p1: java.lang.Exception?) {
          result.error("LoginError", "LoginError", p0.toString())
        }
      })
    } else if (call.method == "loginWithJWT") {
      val args = call.arguments as? ArrayList<String>
      if (args != null && args.size == 2) {
        BrandMessengerManager.loginWithJWT(activity, args[0], args[1], object : KBMLoginHandler {
          override fun onSuccess(p0: RegistrationResponse, p1: Context?) {
            result.success(p0.toString());
          }

          override fun onFailure(p0: RegistrationResponse?, p1: java.lang.Exception?) {
            result.error("LoginError", "LoginError", p0.toString())
          }
        })
      }
    } else if (call.method == "logout") {
      BrandMessengerManager.logout(activity, object : KBMLogoutHandler {
        override fun onSuccess(p0: Context?) {
          result.success(p0.toString())
        }
        override fun onFailure(p0: Exception?) {
          result.error("LogoutError", "LogoutError", p0.toString())
        }
      })
    } else if (call.method == "monitorUnreadCount") {
      BrandMessenger.connectPublishWithVerifyTokenAfter(
        activity!!,
        activity?.getString(R.string.com_kbm_auth_token_loading_message),
        0
      )
    } else if (call.method == "registerDeviceForPushNotification") {
      FirebaseMessaging.getInstance().getToken()
        .addOnCompleteListener { task ->
          val token: String? = task.getResult()
          BrandMessenger.registerForPushNotification(
            activity,
            token,
            object : KBMPushNotificationHandler {
              override fun onSuccess(registrationResponse: RegistrationResponse) {
                result.success("BrandMessenger: FCM registerForPushNotification Success")
              }

              override fun onFailure(
                registrationResponse: RegistrationResponse,
                exception: Exception
              ) {
                result.success("BrandMessenger: FCM registerForPushNotification Failed")
              }
            })
        }
    } else if (call.method == "sendWelcomeMessageRequest") {
      BrandMessengerManager.sendWelcomeMessageRequest(activity)
    } else if (call.method == "setAppModuleName") {
      val args = call.arguments as? String
      BrandMessengerUserPreference.getInstance(activity).appModuleName = args
    } else if (call.method == "setAuthenticationHandlerUrl") {
      val args = call.arguments as? String
      BrandMessengerUserPreference.getInstance(activity).customAuthHandlerUrl = args
    } else if (call.method == "setBaseURL") {
      val args = call.arguments as? String
      BrandMessengerUserPreference.getInstance(activity).url = args
    } else if (call.method == "setRegion") {
      val args = call.arguments as? String
      BrandMessengerManager.setRegion(activity, args)
    } else if (call.method == "setUsePersistentMessagesStorage") {
      result.notImplemented()
    } else if (call.method == "show") {
      BrandMessengerManager.show(activity)
    } else if (call.method == "showWithWelcome") {
      BrandMessengerManager.showWithWelcome(activity)
    } else if (call.method == "updateUserAttributes") {
      val args = call.arguments as? Map<*, *>
      val displayName = args?.get("displayName") as? String
      val userImageLink = args?.get("userImageLink") as? String
      val localURL = args?.get("localURL") as? String
      val userStatus = args?.get("userStatus") as? String
      val contactNumber = args?.get("contactNumber") as? String
      val metadata = args?.get("metadata") as? Map<String, String>
      activity?.let {
        Executors.newSingleThreadExecutor().execute(Runnable {
          val response = UserService.getInstance(it).updateDisplayNameORImageLink(displayName, userImageLink, localURL, userStatus, contactNumber, metadata)
          response?.let { result.success(response) }
                  ?:run { result.error("BM_UPDATE_USER_ERROR", "Failed to update user details", "Error while updating user attributes")}
        })
      }
    } else {
      result.notImplemented()
    }
  }

  var unreadCountBroadcastReceiver: BroadcastReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent) {
      if (BrandMessengerConstants.BRAND_MESSENGER_UNREAD_COUNT == intent.action) {
        val messageDatabaseService = MessageDatabaseService(context)
        val unreadCount = messageDatabaseService.totalUnreadCount
        channel.invokeMethod("receiveUnreadCount", unreadCount)
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity

    BrandMessengerManager.setConversationDelegate(conversationDelegate);

    LocalBroadcastManager.getInstance(activity!!).registerReceiver(unreadCountBroadcastReceiver, IntentFilter(BrandMessengerConstants.BRAND_MESSENGER_UNREAD_COUNT))
    BrandMessenger.connectPublishWithVerifyTokenAfter(
      activity!!,
      activity?.getString(R.string.com_kbm_auth_token_loading_message),
      0
    )
  }

  override fun onDetachedFromActivityForConfigChanges() {
    BrandMessenger.disconnectPublish(activity!!)
    LocalBroadcastManager.getInstance(activity!!).unregisterReceiver(unreadCountBroadcastReceiver)
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    LocalBroadcastManager.getInstance(activity!!).registerReceiver(unreadCountBroadcastReceiver, IntentFilter(BrandMessengerConstants.BRAND_MESSENGER_UNREAD_COUNT))
    BrandMessenger.connectPublishWithVerifyTokenAfter(
      activity!!,
      activity?.getString(R.string.com_kbm_auth_token_loading_message),
      0
    )
  }

  override fun onDetachedFromActivity() {
    BrandMessenger.disconnectPublish(activity!!)
    LocalBroadcastManager.getInstance(activity!!).unregisterReceiver(unreadCountBroadcastReceiver)
    activity = null
  }

  // MessageActionDelegate is a synchronous action that required a boolean return value.
  fun setMessageActionDelegate() {
    BrandMessengerManager.setMessageActionDelegate(object: KBMMessageActionDelegate {
      override fun onAction(
        p0: Context?,
        p1: String?,
        p2: Message?,
        p3: Any?,
        p4: MutableMap<String, Any>?
      ): Boolean {
        return true
      }
    })
  }

  // KBMAuthenticationDelegate is a synchronous action that required a string return value.
  fun setAuthenticationDelegate() {
    BrandMessenger.getInstance(activity).setAuthenticationDelegate { object : KBMAuthenticationDelegate {
      override fun onRefreshFail(p0: KBMAuthenticationDelegateCallback?) {
        // Attempt to refresh token has failed. Provide a new authentication token here to relogin, or return empty string and log user back in later.
        p0?.updateToken("")
      }
    } }
  }

  private var conversationDelegate: KBMConversationDelegate = object : KBMConversationDelegate {
    override fun modifyMessageBeforeSend(p0: Message): Message {
      var available: Semaphore = Semaphore(0)

      var messageMetadata: Map<String, String>? = p0.metadata
      activity?.runOnUiThread {
      channel.invokeMethod(
        "modifyMessageBeforeSend",
        p0.metadata,
        object : MethodChannel.Result {
          override fun success(result: Any?) {
            p0.metadata = result as Map<String, String>
            available.release()
          }

          override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
            available.release()
          }

          override fun notImplemented() {
            available.release()
          }
        })
      }
      available.acquire()
      return p0
    }
  }
}