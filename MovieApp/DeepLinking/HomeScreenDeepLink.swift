//
//  HomeScreenDeepLink.swift
//  MovieApp
//
//  Created by Ahmad medo on 05/07/2023.
//

import UIKit

final class HomeScreenDeeplinkHandler: DeeplinkHandlerProtocol {
    
    private weak var rootController: UIViewController?
    //
    init(rootController: UIViewController?) {
        self.rootController = rootController
    }
    
    // MARK:  DeeplinkHandlerProtocol
    
    func canOpenURL(_ url: URL) -> Bool {
        return url.absoluteString == "movieAppTask://home"
    }
    
    func openURL(_ url: URL) {
        guard canOpenURL(url) else {
            return
        }
        
//        let sb = UIStoryboard(name: "Main", bundle: nil)
        
//        guard let homeVC = sb.instantiateViewController(withIdentifier: "MovieListViewController") as? MovieListViewController else { return }
        
        
//        if let navigationController = rootController as? UINavigationController {
//            navigationController.setViewControllers([homeVC], animated: true)
//        } else {
//            let navigationController = UINavigationController(rootViewController: homeVC)
//            rootController?.present(navigationController, animated: true)
//        }
    }
}

