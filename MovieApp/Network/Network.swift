
import Foundation
import Alamofire
import SwiftyJSON

typealias NetworkCompletion<T> = (AFResult<T>) -> Void


protocol NetworkConnectionGenericProtocol: AnyObject {
    
    func performGet<T:Codable>(_ request: URLRequestConvertible,
                               _ type: T.Type,
                               completionHandler: @escaping NetworkCompletion<T>)
}

class NetworkConnectionGeneric: NetworkConnectionGenericProtocol{
    
    
    private let networkMiddleware = NetworkMiddleware()
    
    private lazy var manager: Session = {
        let manager = networkMiddleware.sessionManager
        return manager
    }()
    
    func performGet<T:Codable>(_ request: URLRequestConvertible,
                               _ type: T.Type,
                               completionHandler: @escaping NetworkCompletion<T>){
        
        #if DEBUG
        print(request.urlRequest?.headers, "request headers")
        
        
        print(manager.sessionConfiguration.headers.dictionary, "session headers")
        #endif
        manager.request(request).responseDecodable(of: type){
            response in
#if DEBUG

            print("response model", response.response)
#endif
            completionHandler(self.process(response: response,
                                           decodedTo: type))
        }
    }
    
    // MARK: - Process
    func process<T:Codable>(response: DataResponse<T, AFError>,
                            decodedTo type: T.Type) -> AFResult<T> {
        
        switch response.result {
        case .success:
            guard let data = response.data else {
                return .failure(NSError.create(description:"Something went wrong") as! AFError)
            }
#if DEBUG
            print(JSON(response.data ?? [:]), "data before parsing")
#endif
            do {
                let data = try JSONDecoder.decodeFromData(type, data: data)
#if DEBUG

                print(JSON(response.data ?? [:]), "astrix data after parsing")
#endif

                return .success(data)
            } catch {
#if DEBUG
                print(type, String(describing: error))
#endif
                return .failure(AFError.responseSerializationFailed(reason: .customSerializationFailed(error: NSError.create(description: "Server Error."))))
            }
            
        case .failure(let error):
#if DEBUG
            print(type, String(describing: error))
#endif
            
            if error.localizedDescription.contains("JSON") {
                return .failure(AFError.responseSerializationFailed(reason: .customSerializationFailed(error: NSError.create(description: "Server Error."))))
            }
            return .failure(error)
        }
    }
    
}

// MARK: - Middleware
class NetworkMiddleware: RequestAdapter {
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {}
    
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default // Alamofire's default URLSessionConfiguration
        configuration.httpAdditionalHeaders = configuration.headers.dictionary
        
        // global headers
        configuration.headers["accept"] = "application/json"
        
        configuration.headers["Authorization"] = "Bearer \(NetworkConstants.apiKey)"
        
        return Session(configuration: configuration)
    }()
}


extension NSError {
    class func create(description: String) -> NSError {
        return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
    }
}


