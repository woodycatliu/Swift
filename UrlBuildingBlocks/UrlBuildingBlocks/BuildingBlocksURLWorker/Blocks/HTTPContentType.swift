//
//  HTTPContentType.swift
//  UrlBuildingBlocks
//
//  Created by Woody on 2021/3/10.
//

import Alamofire

/// HTTP Content Type
/// 產出不同 相對應的 alamofire request

enum HTTPContentType {
    case urlencoded
    case multipartFormData
    
    func buildRequest(_ convertible: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?)-> DataRequest{
    
        switch self {
        case .urlencoded:
            return AF.request(convertible, method: method, parameters: parameters, encoding: encoding, headers: headers)
        case .multipartFormData:
            
            return AF.upload(multipartFormData: {
                multipartFormData in
                for (key, value) in parameters! {

                    guard let data = (value as? String)?.data(using: .utf8) else {break}
                    multipartFormData.append(data, withName: key)
                }
                
            }, to: convertible, method: method, headers: headers)
        }
    }
}
