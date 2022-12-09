package com.brandmessenger.flutter_brandmessenger_sdk

import android.util.Log
import com.brandmessenger.core.KBMFirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class FlutterKBMFirebaseMessagingService: KBMFirebaseMessagingService() {
    override fun onNewToken(registrationId: String) {
        super.onNewToken(registrationId)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
    }
}