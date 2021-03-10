//
//  BaseDecision_RefreshToken_401.swift
//  IOS_Costco
//
//  Created by Woody on 2021/3/9.
//  Copyright © 2021 CMoney. All rights reserved.
//

import Foundation

struct BaseDecisionRelogin405: Decision {
    
    func shouldApply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse) -> Bool where Req: Request {
        return response.statusCode == 405
    }
    
    func apply<Req>(_ request: Req, data: Data?, response: HTTPURLResponse, closure: @escaping (DecisionAction<Req>) -> Void) where Req: Request {
        
        guard relogin() else {
            closure(.errored(.notLogin))
            return
        }
        
        closure(.restartWith(request.decisions))
        
    }
    
    private func relogin()-> Bool {
        return true
    }
    
    
}
