//
//  MovieDetailsDeepLinkHandler.swift
//  MovieApp
//
//  Created by Ahmad medo on 05/07/2023.
//

import UIKit

final class MovieDetailsDeeplinkHandler: DeeplinkHandlerProtocol {
    
    private weak var rootController: UIViewController?
//
    init(rootController: UIViewController?) {
        self.rootController = rootController
    }
    
    // MARK:  DeeplinkHandlerProtocol
    func canOpenURL(_ url: URL) -> Bool {
        
        return url.absoluteString.hasPrefix("movieAppTask://details_screen")
        
    }
    
    func openURL(_ url: URL) {
        guard canOpenURL(url) else {
            return
        }
        
        let id = String(url.path.dropFirst())
                
//        // mock the navigation
        let sb = UIStoryboard(name: "Main", bundle: nil)
//
        guard let movieDetailsScreen = sb.instantiateViewController(withIdentifier: "details") as? DetailsViewController else { return }
        
        movieDetailsScreen.movieId = Int(id)
        
        if let navigationController = rootController as? UINavigationController {
            navigationController.pushViewController(movieDetailsScreen, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: movieDetailsScreen)
            rootController?.present(navigationController, animated: true)
        }

    }
}


