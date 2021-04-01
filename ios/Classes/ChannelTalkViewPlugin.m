#import "ChannelTalkViewPlugin.h"
#if __has_include(<channel_talk_view/channel_talk_view-Swift.h>)
#import <channel_talk_view/channel_talk_view-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "channel_talk_view-Swift.h"
#endif

@implementation ChannelTalkViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftChannelTalkViewPlugin registerWithRegistrar:registrar];
}
@end
