//
//  Logger.swift
//  IOS_Costco
//
//  Created by CHIN WEI KUO on 2020/7/8.
//  Copyright © 2020 CMoney. All rights reserved.
//

import Foundation
import UIKit

class Logger {
    
    private init() {
    }
    
    static func log<T>(message: T, file: String = #file, method: String = #function) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        NSLog("[\(fileName): \(method)] \(message)")
        #endif
    }
    
    static func log<T, U>(message: T, caller: U, method: String = #function) {
        #if DEBUG
        NSLog("[\(caller).\(method)] \(message)")
        #endif
    }
}
