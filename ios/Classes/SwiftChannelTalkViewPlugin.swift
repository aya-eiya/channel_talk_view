import Flutter
import UIKit
import ChannelIO

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ChannelIO.initialize(application)
    return true
}

public class SwiftChannelTalkViewPlugin: NSObject, FlutterPlugin {
  override init() {
    self.pluginKey = ""
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "channel_talk_view", binaryMessenger: registrar.messenger())
    let instance = SwiftChannelTalkViewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  private var pluginKey: String

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "init":
        let argMaps = call.arguments as? [String: Any] ?? [:]
        self.pluginKey = argMaps["pluginKey"] as? String ?? ""
        result(true)
      case "boot":
        self.boot(call, result)
      case "show":
        ChannelIO.showChannelButton()
      case "hide":
        ChannelIO.hideChannelButton()
        ChannelIO.hideMessenger()
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  private func boot(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    let bootConfig = BootConfig.init(
        pluginKey: self.pluginKey
    )
    ChannelIO.boot(with: bootConfig) { (completion, user) in
      if completion == .success, let _ = user {
        result(true)
      } else {
        result(false)
      }
    }
  }
}
