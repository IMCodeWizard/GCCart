//
//  Logger.swift
//  GCCart
//
//  Created by Ninja on 21/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import Foundation


import SwiftyJSON


class Logger: NSObject {
    
    //static let sharedLog = Logger()
    
    static let LOGGER_SPACER_TOP = "\n\n------------- Logger by iOS Ninja -------------\n\n"
    static let LOGGER_SPACER_END = "\n------------------------- END -------------------------\n\n"
    
    
    class func mainLog(className: String, description: Any) {
        
        var info: Any?
        
        if description is NSDictionary || description is NSArray {
            info = JSON(description).description
        }else{
            info = description
        }
        
        
        #if DEBUG
            NSLog("\(LOGGER_SPACER_TOP)Class: \(className)\n\nDescription:\n\(String(describing: info!))\(LOGGER_SPACER_END)\n")
        #endif
        
    }
}
