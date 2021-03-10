//
//  ParameterEncoding.swift
//  UrlBuildingBlocks
//
//  Created by Woody on 2021/3/10.
//

import Alamofire

enum AlamofireParameterEncoding {
    
    case jsonEncoding
    case urlEncoding
    case custom(encoding: ParameterEncoding)
    
    var encoding: ParameterEncoding {
        switch self {
        case .jsonEncoding:
            return JSONEncoding.default
            
        case .urlEncoding:
            return URLEncoding.default
            
        case .custom(let encoding):
            return encoding
        }
    }
}
