//
//  BaseDecision_300To400.swift
//  IOS_Costco
//
//  Created by Woody on 2021/2/8.
//  Copyright © 2021 CMoney. All rights reserved.
//

import Foundation

struct BaseDecision401: Decision {
    
    func shouldApply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse) -> Bool where Req: Request {
        return response.statusCode == 401
    }
    
    
    func apply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse, closure: @escaping (DecisionAction<Req>) -> Void) where Req: Request {
        Logger.log(message: "status code: \(response.statusCode)", caller: request.apiAdapter)

        
        guard let data = data else {
            closure(.errored(.somethingError))
            return }
        
        do {
            let value = try JSONDecoder().decode(Req.Response.self, from: data)
            var res = request.response
            res.value = value
            
            closure(.done(res))
        } catch {
            Logger.log(message: error, caller: request.apiAdapter)
            
            closure(.errored(.somethingError))
        }
    }
    
    
}



struct BaseDecision406: Decision {
    
    
    func shouldApply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse) -> Bool where Req: Request {
        return response.statusCode == 406
    }
    
    func apply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse, closure: @escaping (DecisionAction<Req>) -> Void) where Req: Request {

        Logger.log(message: "status code: \(response.statusCode)", caller: request.apiAdapter)

        closure(.errored(.somethingError))
    }
    
    
}


struct BaseDecision400To499: Decision {
    
    func shouldApply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse) -> Bool where Req: Request {
        return (400...499).contains(response.statusCode)
    }
    
    func apply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse, closure: @escaping (DecisionAction<Req>) -> Void) where Req: Request {

        Logger.log(message: "status code: \(response.statusCode)", caller: request.apiAdapter)

        closure(.errored(.somethingError))
    }
    
}



struct BaseDecisionOutOfRange: Decision {
    
    func shouldApply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse) -> Bool where Req: Request {
        return true
    }
    
    func apply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse, closure: @escaping (DecisionAction<Req>) -> Void) where Req: Request {
        
        Logger.log(message: "status code: \(response.statusCode)", caller: request.apiAdapter)

        closure(.errored(.somethingError))
    }
    
    
}
