import Flutter
import UIKit
import ChannelIO

public class SwiftChannelTalkViewPlugin: NSObject, FlutterPlugin,UNUserNotificationCenterDelegate {
    private var pluginKey: String
    private var center: UNUserNotificationCenter
    private var application: UIApplication

    override init() {
        self.pluginKey = ""
        self.center = UNUserNotificationCenter.current()
        self.application = UIApplication.shared
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "channel_talk_view", binaryMessenger: registrar.messenger())
        let instance = SwiftChannelTalkViewPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "init":
                self.initApp()
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
            case "openNotification":
                if ChannelIO.hasStoredPushNotification() {
                    ChannelIO.openStoredPushNotification()
                    result(true)
                } else {
                    result(false)
                }
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if ChannelIO.isChannelPushNotification(userInfo) {
            ChannelIO.receivePushNotification(userInfo)
            ChannelIO.storePushNotification(userInfo)
        } else {
            ChannelIO.showMessenger()
        }
        completionHandler()
    }

    private func initApp() {
        self.center.delegate = self
        self.center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if (granted) {
                self.application.registerForRemoteNotifications()
            }
        }
        ChannelIO.initialize(self.application)
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
