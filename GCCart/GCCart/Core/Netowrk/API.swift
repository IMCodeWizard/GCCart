//
//  API.swift
//  GCCart
//
//  Created by Ninja on 20/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


class API {
    
    class func getCartItems() -> APIStruct {
        let end_point = "http://www.mocky.io/v2/59c791ed1100005300c39b93"
        return APIStruct(URL: end_point, params: nil, method: .get)
    }
}



//MARK: - API Builder

enum ApiType {
    case getCartItems
}

struct APIStruct {
    let URL: String
    let params: [String : Any]?
    let method: HTTPMethod
    var headers: HTTPHeaders {
        let defaultHeaders = APIStruct.defaultHTTPHeaders
        /*
         guard let authToken = StorageManager.sharedStorage.app_token else { return defaultHeaders }
         defaultHeaders["Authorization"] = "Bearer " + authToken */
        return defaultHeaders
    }
}

extension APIStruct {
    
    /// Creates default values for the "Accept-Encoding", "Accept-Language" and "User-Agent" headers.
    public static let defaultHTTPHeaders: HTTPHeaders = {
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        
        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")
        
        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        // Example: `iOS Example/1.0 (org.alamofire.iOS-Example; build:1; iOS 10.0.0) Alamofire/4.0.0`
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                
                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    
                    let osName: String = {
                        #if os(iOS)
                        return "iOS"
                        #elseif os(watchOS)
                        return "watchOS"
                        #elseif os(tvOS)
                        return "tvOS"
                        #elseif os(macOS)
                        return "OS X"
                        #else
                        return "Unknown"
                        #endif
                    }()
                    
                    return "\(osName) \(versionString)"
                }()
                
                return "\(executable) v\(appVersion)(\(bundle); build:\(appBuild); \(osNameVersion);)"
            }
            
            return "GCCart"
        }()
        
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()
    
}
