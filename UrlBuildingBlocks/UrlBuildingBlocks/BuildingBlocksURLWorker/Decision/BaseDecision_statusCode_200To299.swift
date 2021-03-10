//
//  BaseDecision_statusCode200_300.swift
//  IOS_Costco
//
//  Created by Woody on 2021/2/8.
//  Copyright © 2021 CMoney. All rights reserved.
//

import Foundation


/// 判斷 status Code 200-299
struct BaseDecision200To299: Decision {
    
    func shouldApply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse) -> Bool where Req: Request {
        return (200...299).contains(response.statusCode)

    }
    
    
    func apply<Req: Request>(_ request: Req, data: Data?, response: HTTPURLResponse, closure: @escaping (DecisionAction<Req>) -> Void) {
       
        Logger.log(message: "status code: \(response.statusCode)", caller: request.apiAdapter)

        guard let data = data else {
            closure(.errored(.somethingError))
            return
        }
        
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


struct BaseDecisionDoNothingForSuccess: Decision{
    
    func shouldApply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse) -> Bool where Req: Request {
        Logger.log(message: "status code: \(response.statusCode)", caller: request.apiAdapter)

        return (200...299).contains(response.statusCode)
    }
    
    func apply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse, closure: @escaping (DecisionAction<Req>) -> Void) where Req: Request {
        Logger.log(message: "status code: \(response.statusCode)", caller: request.apiAdapter)

        closure(.done(request.response))
    }
    
    
    
    
    
    
}

