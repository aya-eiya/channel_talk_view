package jp.ayaeiya.channel.channel_talk_view

import android.app.Application
import androidx.annotation.NonNull
import com.zoyi.channel.plugin.android.ChannelIO
import com.zoyi.channel.plugin.android.open.callback.BootCallback
import com.zoyi.channel.plugin.android.open.config.BootConfig
import com.zoyi.channel.plugin.android.open.enumerate.BootStatus
import com.zoyi.channel.plugin.android.open.model.User

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ChannelTalkViewPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel
  private lateinit var pluginKey: String

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val application = flutterPluginBinding.applicationContext as Application

    ChannelIO.initialize(application)
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "channel_talk_view")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "init" -> {
        pluginKey = call.argument<String>("pluginKey") ?: ""
        result.success(true)
      }
      "boot" -> {
        val callBack = BootCallback { bootStatus: BootStatus, user: User? ->
          if (bootStatus == BootStatus.SUCCESS) {
            result.success(true)
          } else {
            result.error("ChannelBootFailed","channel boot error", "$bootStatus")
          }
        }
        try {
          val bootConfig = BootConfig.create(pluginKey)
          ChannelIO.boot(bootConfig, callBack)
        }catch(e: Throwable) {
          result.error("ChannelBootFailed", pluginKey, e)
        }
      }
      "show" -> {
        ChannelIO.showChannelButton()
      }
      "hide" -> {
        ChannelIO.hideChannelButton()
        ChannelIO.hideMessenger()
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
