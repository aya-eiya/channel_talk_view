import 'dart:async';

import 'package:flutter/services.dart';

class ChannelTalkView {
  static const MethodChannel _channel =
      const MethodChannel('channel_talk_view');

  static Future<bool> init(String pluginKey) async {
    final bool isOk = await _channel.invokeMethod('init',
        Map<String, String>()..putIfAbsent("pluginKey", () => pluginKey));
    return isOk;
  }

  static Future<bool> boot() async {
    final bool isOk = await _channel.invokeMethod('boot');
    return isOk;
  }

  static Future<bool> show() async {
    final bool isOk = await _channel.invokeMethod('show');
    return isOk;
  }
}
