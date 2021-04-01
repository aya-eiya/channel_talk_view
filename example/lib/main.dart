import 'package:flutter/material.dart';
import 'dart:async';
import 'package:channel_talk_view/channel_talk_view.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String pluginKey = '';
  String error = '';
  bool initialized = false;
  final _ctrl = TextEditingController();

  void onPluginKeySet() {
    if (_ctrl.value.text != pluginKey) {
      setState(() async {
        try {
          pluginKey = _ctrl.value.text;
          initialized = (await ChannelTalkView.init(pluginKey) &&
              await ChannelTalkView.boot());
          if (initialized) {
            Timer.periodic(Duration(seconds: 5), (t) {
              ChannelTalkView.openNotification();
            });
            ChannelTalkView.show();
          }
          error = '';
        } on PlatformException catch (e) {
          error = '$e';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Text(initialized ? 'initialized' : 'set your pluginKey'),
            if (error != '') Text(error, style: TextStyle(color: Colors.red)),
            Text('pluginKey : '),
            if (!initialized)
              TextField(
                controller: _ctrl,
                onSubmitted: (v) => onPluginKeySet(),
              ),
            if (initialized) Text(pluginKey)
          ]),
        ),
      ),
    );
  }
}
