//
//  Request.swift
//  UrlBuildingBlocks
//
//  Created by Woody on 2021/3/10.
//

import Alamofire

protocol Request {
    associatedtype Response: Codable
    
    var response: HTTPResponse<Response> { get }
    var method: HTTPMethod { get }
    var apiAdapter: APIAdapter { get }
    var contentType: HTTPContentType { get }
    var parametersEncoding: AlamofireParameterEncoding { get }
    var decisions: [Decision] { get }
    func buildRequest(domin: String, user: UserData)-> DataRequest
    
}


extension Request {
    
    var response: HTTPResponse<Response> {
        return HTTPResponse<Response>.init(value: nil, response: nil, error: nil)
    }
    
    func buildRequest(domin: String, user: UserData)-> DataRequest {
        
        let endpoint: String = apiAdapter.endPoint(user: user)
        let headers: HTTPHeaders? = apiAdapter.headers(user: user)
        let parameters: Parameters? = apiAdapter.parameters(user: user)
        
        let urlString = domin + endpoint
        
        return contentType.buildRequest(urlString, method: method, parameters: parameters, encoding: parametersEncoding.encoding, headers: headers)
    }
    
}
