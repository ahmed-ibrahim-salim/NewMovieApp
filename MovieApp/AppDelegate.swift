//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Ahmed medo 04/07/2023.
//

import UIKit
import Firebase
import FirebaseCore
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var deeplinkCoordinator: DeeplinkCoordinatorProtocol = {
            return DeeplinkCoordinator(handlers: [
                HomeScreenDeeplinkHandler(rootController: rootController),
                MovieDetailsDeeplinkHandler(rootController: rootController)
            ])
    }()
//
    var rootController: UIViewController? {
        return window?.rootViewController
    }
//
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        FirebaseApp.configure()
        registerNotificationMethods(currentApplication: application)

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }


}
// deep linking for app delegate
extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
#if DEBUG

        print(url.absoluteString)
#endif

        return deeplinkCoordinator.handleURL(url)

//        return true
    }
    
}


// MARK: Notifications Configure
extension AppDelegate: UNUserNotificationCenterDelegate {
    // 1) initiate
    func registerNotificationMethods(currentApplication : UIApplication){
                
        UNUserNotificationCenter.current().delegate = self
        
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {
                granted, error in
#if DEBUG

                print(granted, "request Authorization isGranted")
#endif
            })
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    // 2)
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
#if DEBUG

        print(error, "failed to register for remote notification error")
#endif

    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
#if DEBUG

        print(deviceToken, "device token", "did success Register For Remote Notifications")
        
        // pass token to (firebase messaging)
        Messaging.messaging().apnsToken = deviceToken
#endif
    }
    
    // 3)
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
#if DEBUG

        print(userInfo, "notification userinfo")
        completionHandler(UIBackgroundFetchResult.newData)
#endif
    }
    // 4)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
#if DEBUG

        print(response.notification.request.content.userInfo, "userNotificationCenter, didReceive")
#endif

    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
#if DEBUG

        // handle notification when app in foreground
        print(notification.request.content.userInfo, "userNotificationCenter, willPresent")
        
        completionHandler([.list, .badge, .sound])
#endif

    }
}
// MARK: Firebase Messaging
extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging,
                   didReceiveRegistrationToken fcmToken: String?) {
        #if DEBUG
        print(fcmToken, "did Receive Registration for messaging Token")
        #endif
    }
}
