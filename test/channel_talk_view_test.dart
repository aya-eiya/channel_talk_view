import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:channel_talk_view/channel_talk_view.dart';

void main() {
  const MethodChannel channel = MethodChannel('channel_talk_view');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ChannelTalkView.init('909cd626-0d6f-4c8d-8ee3-5beba9fa3d73'),
        true);
  });
}
