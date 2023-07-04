//
//  ViewController.swift
//  MovieApp
//
//  Created by Ahmed medo 04/07/2023.
//

import UIKit
import Alamofire

class MovieListViewController: UIViewController {
    
    // MARK: IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    
    var moviesPaginationHandler: MoviesPageWithPagination!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredMovies: [Movie] = []
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pagination handler
        moviesPaginationHandler = MoviesPageWithPagination(controller: self)
        
        setupTableView()
        
        getMovies()
        
    }
    
    // table
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    private func makeUrlWithPage(url: URL,_ page: Int)->URL{
        let newUrl = "\(url.absoluteString)/?page=\(page)"
        
        guard let urlWithPage = URL(string: newUrl) else{ fatalError()}
        
        return urlWithPage
        
    }
    //MARK: Network
    
}

// MARK: Prefetching
extension MovieListViewController: UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        moviesPaginationHandler.startFetchingOrNot(indexRow: indexPaths.last!.row)
    }
}

// MARK: Table
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesPaginationHandler.innerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell",for: indexPath) as! MovieListTableViewCell
        
        cell.configure(with: moviesPaginationHandler.innerList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "details") as! DetailsViewController
        
        
        vc.movieDetails = moviesPaginationHandler.innerList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y:cell.contentView.frame.width)
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1 * Double(indexPath.row),
                       animations: {
            
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width,
                                               y: cell.contentView.frame.height)
            cell.alpha = 1
            
        })
    }
}

extension MovieListViewController{
    
    func getMovies(page: Int = 1){
        
        let apiKey = "80adae09b523d3037018900367438854"
        
        let baseURL = "https://api.themoviedb.org/3/movie/"
        let imagebaseURL = "https://image.tmdb.org/t/p/w500/"
        
        guard let url = URL(string: "\(baseURL)popular?api_key=\(apiKey)&page=\(page)") else {
#if DEBUG
            print("invalid url, please check url")
#endif
            
            return
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
#if DEBUG
        print("Request headers",headers)
#endif
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
        .responseDecodable(of: MoviesModel.self) {
            
            response in
            guard let data = response.data else {return}
            
            do{
                let res = try JSONDecoder().decode(MoviesModel.self, from: data)
                
                if let movies = res.results{
                    
                    var movieArra: [Movie] = movies
                    var index = 0
                    
                    for movie in movieArra{
                        
                        let newimageurl = imagebaseURL + (movie.posterPath ?? "")
                        let newBackImage = imagebaseURL + (movie.backdropPath ?? "")
                        movieArra[index].posterPath = newimageurl
                        movieArra[index].backdropPath = newBackImage
                        
                        index += 1
                    }
                    
                    self.moviesPaginationHandler.passListAndItemTotalFromApi(list: movieArra,
                                                                             totalFavsFromApi: 100)
                }                
                
            } catch {
                print(error)
            }
        }
    }
}


