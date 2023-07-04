
import Foundation
import Alamofire

protocol RequestHandlerProtocol: AnyObject{

    func getPopularMovies(params: [String : Any],
                               completionHandler: @escaping (AFResult<MoviesModel>) -> ())
}


class RequestsHandler: RequestHandlerProtocol {

    static let shared = RequestsHandler()

    var network: NetworkConnectionGenericProtocol?
    
    init(network: NetworkConnectionGenericProtocol = NetworkConnectionGeneric()) {
        
        self.network = network
    }

    func getPopularMovies(params: [String : Any],
                             completionHandler: @escaping (AFResult<MoviesModel>) -> ()){
        
        print(params, "getPopularMovies")
        network?.performGet(Routers.getPopularMovies(para: params),
                            MoviesModel.self){
            response in
            completionHandler(response)
        }
    }
    
    
    func getMovieById(params: [String : Any],
                             completionHandler: @escaping (AFResult<Movie>) -> ()){
        
        print(params, "getMovieById")
        network?.performGet(Routers.movieById(para: params),
                            Movie.self){
            response in
            completionHandler(response)
        }
    }
}
