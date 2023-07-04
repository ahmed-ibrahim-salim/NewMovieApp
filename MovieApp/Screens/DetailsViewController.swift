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
    
    @IBAction func watchMovieBtnPressed(_ sender: Any) {
        
//        if let url = URL(string: movieDetails?.url ?? "www.google.com") {
//            UIApplication.shared.open(url)
//        } else {
//            print("url is not correct")
//        }
        
    }
    
//    func getMovie(id: String){
//        
//        let apiKey = "80adae09b523d3037018900367438854"
//        
//        let baseURL = "https://api.themoviedb.org/3/movie/"
//        let imagebaseURL = "https://image.tmdb.org/t/p/w500/"
//        
//        guard let url = URL(string: "\(baseURL)popular?api_key=\(apiKey)&page=\(page)") else {
//#if DEBUG
//            print("invalid url, please check url")
//#endif
//            return
//        }
//        
//        let headers: [String : Any] = [
//            "Accept": "application/json",
//            "Authorization" : "Bearer \(apiKey)"
//        ]
//        
//#if DEBUG
//        print("Request headers",headers)
//#endif
//        
//        AF.request(url,
//                   method: .get,
//                   encoding: URLEncoding.default,
//                   headers: headers)
//        .responseDecodable(of: MoviesModel.self) {
//            
//            response in
//            guard let data = response.data else {return}
//            
//            do{
//                let res = try JSONDecoder().decode(MoviesModel.self, from: data)
//                
//                if let movies = res.results{
//                    
//                    var movieArra = movies
//                    var index = 0
//                    
//                    for movie in movieArra{
//                        
//                        let newimageurl = imagebaseURL + (movie.posterPath ?? "")
//                        let newBackImage = imagebaseURL + (movie.backdropPath ?? "")
//                        movieArra[index].posterPath = newimageurl
//                        movieArra[index].backdropPath = newBackImage
//                        index += 1
//                    }
//                    
//                    self.moviesPaginationHandler.passListAndItemTotalFromApi(list: movieArra,
//                                                                             totalFavsFromApi: 100)
//                }
//                
//            } catch {
//                print(error)
//            }
//        }
//    }
    
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

