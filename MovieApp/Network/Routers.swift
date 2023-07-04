
import Foundation
import Alamofire

enum Routers: URLRequestConvertible {
    
    case getPopularMovies(para: [String: Any])
    
    var url: URL{
        
        switch self {
        case .getPopularMovies:
            var endpoint = NetworkConstants.NetworkEndpoints.popularMovies
            return URL(string: NetworkConstants.baseUrl)!.appendingPathComponent(endpoint)
 
        }}
    
    var method: HTTPMethod{
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]?{
        switch self {
        case .getPopularMovies(para: let para):
            return para
        }
        
    }
    
    var encoding: ParameterEncoding{
        switch self{
            
        default:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return try encoding.encode(request, with: parameters)
    }
}

