package com.example.nested_nav

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val preferences = getSharedPreferences("herrega_progress", Context.MODE_PRIVATE)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "herrega/progress")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "read" -> result.success(preferences.getString("record", null))
                    "write" -> {
                        val record = call.arguments as? String
                        if (record == null) {
                            result.error("INVALID_RECORD", "Progress must be a string.", null)
                        } else {
                            // A successful channel reply confirms the write reached disk.
                            // ProgressStore serialises calls; a synchronous commit prevents
                            // an older asynchronous write from replacing newer progress.
                            val saved = preferences.edit().putString("record", record).commit()
                            if (saved) {
                                result.success(null)
                            } else {
                                result.error("WRITE_FAILED", "Progress could not be saved.", null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
