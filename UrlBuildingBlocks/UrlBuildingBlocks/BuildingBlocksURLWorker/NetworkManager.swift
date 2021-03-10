//
//  NetworkManager.swift
//  UrlBuildingBlocks
//
//  Created by Woody on 2021/3/10.
//

import Alamofire


class NetworkerManager {
    static let shared = NetworkerManager()
    
    private var domain: String {
        return "https://EroticUncle.oo.com/"
    }
    
    private var user: UserData {
        return UserData(id: "9527", guid: "thank you", token: "I dont care")
    }
    
    
    func send<Req: Request>(_ request: Req, decisions: [Decision]? = nil, completion: @escaping (Swift.Result<HTTPResponse<Req.Response>, HTTPError>) -> Void) {
        
        let dataRequest = request.buildRequest(domin: domain, user: user)
        
        dataRequest.response { dataResponse in
            
            if let error = dataResponse.error {
                
                Logger.log(message: error, caller: request.apiAdapter)
                completion(.failure(.somethingError))
                return
            }
            
            guard let response = dataResponse.response else {
                completion(.failure( .somethingError))
                return
            }
            
            let data = dataResponse.data
            
            if let decisions = decisions {
                self.handleDecision(request, data: data, response: response, decisions: decisions, completion: completion)
            } else {
                self.handleDecision(request, data: data, response: response, decisions: request.decisions, completion: completion)
            }
        }
        
    }
    
    
    
    
    /// 處理API 決策
    /// - Parameters:
    ///   - request: 自定義Request CostcoRequestV3
    ///   - codable: decode 型別
    ///   - data: HTTPURL DAta
    ///   - response: HTTPURLResponse
    ///   - decisions: 處理 request 存取的 api return data 解析的決策
    ///   - completion: 回傳結果
    func handleDecision<Req: Request>(_ request: Req, data: Data?, response: HTTPURLResponse, decisions: [Decision], completion: @escaping (Swift.Result<HTTPResponse<Req.Response>, HTTPError>) -> Void) {
        
        guard !decisions.isEmpty else {
            completion(.failure(.somethingError))
            return }
        
        var decisions = decisions
        let current = decisions.removeFirst()
        
        
        guard current.shouldApply(request, data: data, response: response) else {
            handleDecision(request, data: data, response: response, decisions: decisions, completion: completion)
            return
        }
        
        
        current.apply(request, data: data, response: response) {
            action in
            
            switch action {
            
            case .continueWith(let data, let response):
                self.handleDecision(request, data: data, response: response, decisions: decisions, completion: completion)
            case .restartWith(let decisions):
                self.send(request, decisions: decisions) {
                    result in
                    completion(result)
                }
            case .errored(let error):
                completion(.failure(error))
            case .done(let value):
                completion(.success(value))
                
            }
        }
    }

}

