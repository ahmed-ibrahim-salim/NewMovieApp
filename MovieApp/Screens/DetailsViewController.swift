//
//  DetailsViewController.swift
//  MovieApp
//
//  Created by Ahmed medo 04/07/2023.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    // MARK: IBOutlets.
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieGeners: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieFullDescription: UILabel!
    
    var movieDetails: Movie?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        displayDataInTheView()
        watchBtn.layer.cornerRadius = 15
        
    }
    
    // MARK: IBActions.
    @IBAction func watchMovieBtnPressed(_ sender: Any) {
        
        if let url = URL(string: movieDetails?.url ?? "www.google.com") {
            UIApplication.shared.open(url)
        } else {
            print("url is not correct")
        }
        
    }
    
    func displayDataInTheView(){
        
        title = movieDetails?.titleEnglish
        movieYear.text = "\(movieDetails?.year ?? 2000)"
        movieGeners.text = movieDetails?.genres?.joined(separator: ", ")
        
        if movieDetails?.descriptionFull == "" {
            movieFullDescription.text = " This movie didn't have a Description , \n GOOGLE it if you need the Description"
        }else {
            movieFullDescription.text = movieDetails?.descriptionFull
        }
        
        watchBtn.setTitle(movieDetails?.url, for: .normal)
        
        guard let imgURL = URL(string: movieDetails?.backgroundImageOriginal ?? "" ) else { return}
        
        let recource = ImageResource(downloadURL: imgURL)
        
        movieImage.kf.setImage(with: recource)
    }
    
    
}

