#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint channel_talk_view.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'channel_talk_view'
  s.version          = '0.0.1'
  s.summary          = 'Channel talk mobile sdk plugin flutter.'
  s.description      = <<-DESC
Channel talk mobile sdk plugin flutter
                       DESC
  s.homepage         = 'https://github.com/aya-eiya'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'jp.ayaeiya' => 'h.ayabe_biz@live.jp' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'ChannelIOSDK'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
