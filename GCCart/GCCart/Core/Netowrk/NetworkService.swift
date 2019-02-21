//
//  NetworkService.swift
//  GCCart
//
//  Created by Ninja on 20/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import UIKit

class Retrier: RequestRetrier {
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        Logger.mainLog(className: String(describing: self) + "\n\(request.request?.url?.absoluteString ?? "")", description: "\n\(error.localizedDescription) \(error._code)\nRetry count: \(request.retryCount)\n\(JSON(request.request?.httpBody as Any))")
        
        if  -1010 ... -1000 ~= error._code && request.retryCount <= 2{
            completion(true, 1.0) // retry after 1 second
        } else {
            completion(false, 0.0) // don't retry
        }
    }
}

class NetworkService: NSObject {
    
    // Singletone setup configs
    static let sharedService: NetworkService = {
        let instance = NetworkService()
        
        let sessionManager = SessionManager.default
        
        sessionManager.session.configuration.timeoutIntervalForRequest = 60
        sessionManager.retrier = Retrier()
        
        return instance
    }()
    
    // Methods
    
    func invalidateAllSessions(){
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach{ $0.cancel() }
        }
    }
    
    @discardableResult
    func loadImage(urlString: String, success: ((UIImage) -> Void)? = nil, failure: ((_ reason: String) -> Void)? = nil) -> DataRequest {
        let task = Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300).responseImage { (response) in
                switch response.result {
                case .success(let value):
                    success?(value)
                case .failure(let error):
                    failure?(error.localizedDescription)
                }
                
            }
        return task
    }
    
    @discardableResult
    func sendRequestWithService<T: Decodable>(api: APIStruct, success: ((T) -> Void)? = nil, failure: ((_ reason: String) -> Void)? = nil) -> DataRequest {
        
        let task = Alamofire.request(api.URL, method: api.method, parameters: api.params, encoding: JSONEncoding.default, headers: api.headers)
            .validate(statusCode: 200..<300).responseData { [unowned self] response in
                
                switch response.result{
                    
                case .success(let value):
                    // Logger.mainLog(className: String(describing: self) + "\n\(response.request?.url?.absoluteString ?? "")", description: "\nResponse\n\(JSON(value))")
                    
                    switch self.parseObj(rawData: value, generic: T.self) {
                    case .success(let obj):
                        success?(obj)
                    case .failure(let errorDiscription):
                        failure?(errorDiscription)
                    }
                    
                    break
                case .failure(let error):
                    Logger.mainLog(className: String(describing: self) + "\n\(String(describing: response.request?.url))", description: error.localizedDescription)
                    failure?(error.localizedDescription)
                    break
                }
        }
        
     return task
    }
    
    
    //MARK: - Parse Handler
    private func parseObj<T: Decodable>(rawData: Data, generic: T.Type) -> ParseResult<T> {
        do {
            let obj = try T.self.decode(data: rawData)
            return .success(obj)
        } catch let error {
            return .failure(error.localizedDescription)
        }
    }
    
    private enum ParseResult<T> {
        case success(T)
        case failure(String)
    }
}


