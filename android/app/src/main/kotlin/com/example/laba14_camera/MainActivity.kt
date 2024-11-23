package com.example.laba14_camera

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.native_features/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getNativeMessage") {
                    result.success("Hi, Mom! (from Kotlin)")  // Це має повернути відповідь Flutter
                } else {
                    result.notImplemented()  // Якщо метод не знайдений
                }
            }
    }
}

