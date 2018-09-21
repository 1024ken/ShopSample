//
//  HttpManager.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/01/28.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

class HttpManager {
    
    class func get(url: String, completion: @escaping ((Bool, Data?) -> ())) {
        
        HttpManager.request(url: url, method: "GET", body: nil, completion: completion)
    }
    
    class func post(url: String, params: [String: String]?, completion: @escaping ((Bool, Data?) -> ())) {
        
        var paramsString = ""
        params?.forEach { param in
            if paramsString.characters.count > 0 {
                paramsString += "&"
            }
            paramsString += param.key
            paramsString += "="
            paramsString += param.value
        }
        let paramsData = paramsString.data(using: .utf8)
        HttpManager.request(url: url, method: "POST", body: paramsData, completion: completion)
    }
    
    class private func request(url: String, method:String, body: Data?, completion: @escaping ((Bool, Data?) -> ())) {
        
        guard let urlRaw = URL(string: url) else {
            completion(false, nil)
            return
        }
        var request = URLRequest(url: urlRaw, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: Constants.HttpTimeOutInterval)
        request.httpMethod = method
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil, let data = data {
                    completion(true, data)
                } else {
                    completion(false, nil)
                }
            }
        }
        task.resume()
    }
}
