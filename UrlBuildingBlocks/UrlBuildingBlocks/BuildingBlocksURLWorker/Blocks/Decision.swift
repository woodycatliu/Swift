//
//  File.swift
//  UrlBuildingBlocks
//
//  Created by Woody on 2021/3/10.
//

import Foundation

protocol Decision {
    /// check statusCode
    /// if equle go apply
    func shouldApply<Req: Request>(_ request: Req, data: Data?, response: HTTPURLResponse)-> Bool
   
    func apply<Req: Request>(_ request: Req, data: Data?, response: HTTPURLResponse, closure: @escaping (DecisionAction<Req>)-> Void)
}


enum DecisionAction<Req: Request> {
    case continueWith(Data?, HTTPURLResponse)
    case restartWith([Decision])
    case errored(HTTPError)
    case done(HTTPResponse<Req.Response>)
}
