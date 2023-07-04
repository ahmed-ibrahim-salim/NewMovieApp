//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Ahmed medo 04/07/2023.
//

import UIKit

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

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }


}
//// deep linking for app delegate
extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
        print(url.absoluteString)
        return deeplinkCoordinator.handleURL(url)

//        return true
    }
    
}
