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
        
        
        vc.movieId = moviesPaginationHandler.innerList[indexPath.row].id
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

// MARK: Network
extension MovieListViewController{
    
    func getMovies(page: Int = 1){

        let params: [String: Any] = [
            "api_key": NetworkConstants.apiKey,
            "page": page
        ]
        
        RequestsHandler.shared.getPopularMovies(params: params) {
            [weak self] result in
            switch result {
            case .success(let moviesModel):
                if let moviesModelData = moviesModel.results {

                    var movieArra = moviesModelData
                    var index = 0
                    
                    for movie in movieArra{
                        
                        let newimageurl = NetworkConstants.baseImageUrl + (movie.posterPath ?? "")
                        let newBackImage = NetworkConstants.baseImageUrl + (movie.backdropPath ?? "")
                        movieArra[index].posterPath = newimageurl
                        movieArra[index].backdropPath = newBackImage
                        index += 1
                    }
                    
                    self?.moviesPaginationHandler.passListAndItemTotalFromApi(list: movieArra,
                                                                              totalFavsFromApi: 100)
                } else {
                    print("Response has no data")
                }
            case .failure:
                // Handle the failure case if needed
                break
            }
        }
    }
}





