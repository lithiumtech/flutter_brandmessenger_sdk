package com.brandmessenger.flutter_brandmessenger_sdk

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import com.brandmessenger.core.api.account.register.RegistrationResponse
import com.brandmessenger.core.api.account.user.BrandMessengerUserPreference
import com.brandmessenger.core.listeners.KBMLoginHandler
import com.brandmessenger.core.ui.BrandMessengerManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** FlutterBrandmessengerSdkPlugin */
class FlutterBrandmessengerSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var activity: Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_brandmessenger_sdk")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (activity == null) {
      result.error("NoActivity", "NoActivity", "NoActivity")
    }
      if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "initWithCompanyKeyAndApplicationId") {
      val args = call.arguments as? Array<*>
      if (args != null && args.size == 2) {
        BrandMessengerManager.init(activity, args[0] as String?, args[1] as String?)
      }
    } else if (call.method == "setBaseURL") {
      val args = call.arguments as? String
      BrandMessengerUserPreference.getInstance(activity).url = args
    } else if (call.method == "setAuthenticationHandlerUrl") {
      val args = call.arguments as? String
      BrandMessengerUserPreference.getInstance(activity).customAuthHandlerUrl = args
    } else if (call.method == "login") {
      val args = call.arguments as? String
      BrandMessengerManager.login(activity, args, object : KBMLoginHandler {
        override fun onSuccess(p0: RegistrationResponse, p1: Context?) {
        }
        override fun onFailure(p0: RegistrationResponse?, p1: java.lang.Exception?) {
        }
      })
    } else if (call.method == "show") {
      BrandMessengerManager.show(activity)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }
}
