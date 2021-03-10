//
//  BaseRequest.swift
//  IOS_Costco
//
//  Created by Woody on 2021/2/9.
//  Copyright © 2021 CMoney. All rights reserved.
//

import Foundation
import Alamofire

/// 基本通用 API Request， 有特別處理程序，可自性遵守 CostcoRequestV3 自定義
/// 比如 content type : multipartFormData 需要存取 img 與 img file name 時
struct BaseRequest<T: Codable>: Request {

    typealias Response = T
    
    var response: HTTPResponse<Response>
    
    var method: HTTPMethod
    
    var apiAdapter: APIAdapter
    
    var contentType: HTTPContentType
    
    var parametersEncoding: AlamofireParameterEncoding = .jsonEncoding
    
    var decisions: [Decision] = [
        BaseDecision200To299(),
        BaseDecision401(),
        BaseDecision400To499(),
        BaseDecisionOutOfRange()
    ]
    
}
