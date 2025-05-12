import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging     // ← add this
import FirebaseAuth          // ← add this
import UserNotifications     // ← add this
import GoogleSignIn
import flutter_downloader

@main
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1. Firebase
    FirebaseApp.configure()

    // 2. Notifications
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()

    // 3. Plugin registration
    GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Receive APNs device token
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // a) Hand off to FCM
    Messaging.messaging().apnsToken = deviceToken
    // b) Hand off to Auth for phone‐verification
    Auth.auth().setAPNSToken(deviceToken, type: .prod)
  }

  // Handle Google Sign‐In redirect
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}

// MARK: – Background plugin registration
private func registerPlugins(registry: FlutterPluginRegistry) {
  GeneratedPluginRegistrant.register(with: registry)
}
