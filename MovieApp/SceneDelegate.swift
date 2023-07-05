//
//  SceneDelegate.swift
//  MovieApp
//
//  Created by Ahmed medo 04/07/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    
    lazy var deeplinkCoordinator: DeeplinkCoordinatorProtocol = {
            return DeeplinkCoordinator(handlers: [
                HomeScreenDeeplinkHandler(rootController: rootController),
                MovieDetailsDeeplinkHandler(rootController: rootController)
            ])
    }()
//
    var rootController: UIViewController? {
        // mock the navigation
        return window?.rootViewController
    }
    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
   
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }

}
// deep linking for scene delegate
extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {

        guard let firstUrl = URLContexts.first?.url else {
            return
        }
#if DEBUG

        print(firstUrl.absoluteString)
        deeplinkCoordinator.handleURL(firstUrl)
#endif

    }
}
