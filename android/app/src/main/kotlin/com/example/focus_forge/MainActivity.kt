package com.example.focus_forge

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "focusforge/dnd"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE)
                        as NotificationManager

            when (call.method) {

                "requestPermission" -> {

                    if (!notificationManager.isNotificationPolicyAccessGranted) {

                        val intent = Intent(
                            Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS
                        )

                        startActivity(intent)
                    }

                    result.success(null)
                }

                "enableDnd" -> {

                    if (notificationManager.isNotificationPolicyAccessGranted) {

                        notificationManager.setInterruptionFilter(
                            NotificationManager.INTERRUPTION_FILTER_NONE
                        )
                    }

                    result.success(null)
                }

                "disableDnd" -> {

                    if (notificationManager.isNotificationPolicyAccessGranted) {

                        notificationManager.setInterruptionFilter(
                            NotificationManager.INTERRUPTION_FILTER_ALL
                        )
                    }

                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}