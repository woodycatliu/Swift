//
//  APIManager.swift
//  UrlBuildingBlocks
//
//  Created by Woody on 2021/3/10.
//

import Alamofire


/// your API
enum APIManager: APIAdapter {
    
    case search
    
    case login
    
    case showMeTheMoney(value: String)
    
    func endPoint(user: UserData) -> String {
        switch self {
        case .search:
            return "search/\(user.id)/panties"
        case .login:
            return "login"
        case .showMeTheMoney:
            return "money/moreMoney/Mmmmmmm"
        }
    }
    
    func headers(user: UserData) -> HTTPHeaders? {
        switch self {
        case .search:
            return nil
        case .login:
            return nil
        case .showMeTheMoney(let value):
            return [
                "value": value
            ]
        }
    }
    
    func parameters(user: UserData) -> Parameters? {
        switch self {
        
        case .search:
            return [
                "used": "yes",
                "clean": "no"
            ]
        case .login:
            return [
                "guid": user.guid,
                "id": user.id,
                "token": user.token
            ]
            
        case .showMeTheMoney:
            return nil
        }
    }
    
}
