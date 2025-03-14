package com.aotsoft.booklibrary.booklibrary

import RealPathUtil
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.digitalcontent.onepdf/main"
    private var isHome = false
    lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )
        if (!isHome) {
            channel.setMethodCallHandler { call, result ->
                if (call.method == "goToHome") {
                    isHome = true
                    handleIntent()
                }
            }
        } else {
            handleIntent()
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if(intent?.action == Intent.ACTION_VIEW){
            if("application/pdf" == intent.type){
                val path = RealPathUtil.getRealPathFromURI(context, intent.data)
                channel.invokeMethod("openDetail1Lib",path)
            }
        }
    }

    private fun handleIntent() {
        println("channel = $channel")
        println("INTENT TYPE ${intent?.action}")
        when {
            intent?.action == Intent.ACTION_VIEW -> {
                println("INTENT TYPE 1111111 ${intent?.type}")
                if ("application/pdf" == intent.type) {
                    val path = RealPathUtil.getRealPathFromURI(context, intent.data)
                    channel.invokeMethod("openDetail1Lib",path)

                }
            }
        }
    }
}
