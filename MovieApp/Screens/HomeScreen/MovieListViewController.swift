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
    func getMovies(_ page: Int = 1){
        
        let url = URL(string:"https://yts.mx/api/v2/list_movies.json")!
        
        let urlWithPage =  makeUrlWithPage(url: url, page)
                
        AF.request(urlWithPage,
                   method: .get,
                   encoding: JSONEncoding.default)
        .responseDecodable(of: Movies.self) {
            
            (response) in
            guard let data = response.data else {return}
            print(data, "num")
            
            do{
                let res = try JSONDecoder().decode(Movies.self, from: data)
                
                self.moviesPaginationHandler.passListAndItemTotalFromApi(list: res.data?.movies ?? [],
                                                                          totalFavsFromApi: 100)
                
            }catch let error{
                print(error)
            }
        }
    }
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
        return searchController.isActive ? filteredMovies.count : moviesPaginationHandler.innerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell",for: indexPath) as! MovieListTableViewCell
        cell.configure(with: searchController.isActive ? filteredMovies[indexPath.row] : moviesPaginationHandler.innerList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "details") as! DetailsViewController
        
        
        vc.movieDetails = searchController.isActive ? filteredMovies[indexPath.row] : moviesPaginationHandler.innerList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y:cell.contentView.frame.width)
        UIView.animate(withDuration: 0.5, delay: 0.1*Double(indexPath.row), animations: {
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
            cell.alpha = 1
        })
    }
}



