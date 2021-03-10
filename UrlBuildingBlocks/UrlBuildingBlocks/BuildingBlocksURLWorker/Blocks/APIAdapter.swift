//
//  APIAdapter.swift
//  UrlBuildingBlocks
//
//  Created by Woody on 2021/3/10.
//

import Alamofire

protocol APIAdapter {
    func endPoint(user: UserData)-> String
    func headers(user: UserData)-> HTTPHeaders?
    func parameters(user: UserData)-> Parameters?
}
