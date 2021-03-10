//
//  Response.swift
//  UrlBuildingBlocks
//
//  Created by Woody on 2021/3/10.
//

import Foundation

protocol Response {
    associatedtype T: Codable
    var value: T? { get set }
    var response: HTTPURLResponse? { get set }
    var error: Error? { get set}
}

struct HTTPResponse<T: Codable>: Response {
    /// recevice form URL Work
    var value: T?
    
    var response: HTTPURLResponse?
    
    var error: Error?
}
