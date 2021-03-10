//
//  HTTPError.swift
//  UrlBuildingBlocks
//
//  Created by Woody on 2021/3/10.
//

import Foundation


enum HTTPError: Error {
    case somethingError
    case notLogin
    case timeOutErro
    
    var message: String {
        switch  self {
        case .somethingError:
            return "Who care"
        case .notLogin:
            return "Login first, asshole"
        case .timeOutErro:
            return "your shit net line"
        }
    }
    
}
