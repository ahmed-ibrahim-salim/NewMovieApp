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
    
    private var movieDetails: Movie?{
        didSet{
            displayDataInTheView()
        }
    }
    
    var movieId: Int?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        displayDataInTheView()
        watchBtn.layer.cornerRadius = 15
        
        getMovie(by: movieId ?? 1)
    }
    
    @IBAction func watchMovieBtnPressed(_ sender: Any) {
        
//        if let url = URL(string: movieDetails?.url ?? "www.google.com") {
//            UIApplication.shared.open(url)
//        } else {
//            print("url is not correct")
//        }
        
    }
        
    func getMovie(by id: Int){
        //'https://api.themoviedb.org/3/movie/movie_id?language=en-US' \

        let params: [String: Any] = [
            "api_key": NetworkConstants.apiKey,
            "id" : id
        ]
        
        RequestsHandler.shared.getMovieById(params: params) {
            [weak self] result in
            switch result {
            case .success(let movie):
                
                var newMovie = movie
                let newimageurl = NetworkConstants.baseImageUrl + (movie.posterPath ?? "")
                let newBackImage = NetworkConstants.baseImageUrl + (movie.backdropPath ?? "")
                newMovie.posterPath = newimageurl
                newMovie.backdropPath = newBackImage
               
                self?.movieDetails = newMovie
            case .failure:
                // Handle the failure case if needed
                break
            }
        }
    }
    
    func displayDataInTheView(){
        
        title = movieDetails?.title
        movieYear.text = "\(movieDetails?.releaseDate ?? "2000")"
        movieGeners.text = movieDetails?.originalLanguage ?? "EN"
        
        if movieDetails?.overview == "" {
            movieFullDescription.text = " This movie didn't have a Description , \n GOOGLE it if you need the Description"
        }else {
            movieFullDescription.text = movieDetails?.overview
        }
        
        watchBtn.setTitle("Watch now", for: .normal)
        
        guard let imgURL = URL(string: movieDetails?.backdropPath ?? "" ) else { return}
        
        let recource = ImageResource(downloadURL: imgURL)
        
        movieImage.kf.setImage(with: recource)
    }
    
    
}

