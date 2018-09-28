//
//  AuthRequester.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/10.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

class AuthRequester {
    
    //認証情報を定義
    enum Result: String {
        case ok = "0"
        case duplicated = "1"
        case inputError = "2"
        case networkError = "3"
        case error = "4"
        
        init(_ value: String?) {
            self = Result(rawValue: value ?? "") ?? .error
        }
    }
    
    //会員登録を定義
    class func register(email: String, password: String, completion: @escaping ((Result, String?) -> ())) {
        AuthRequester.post(command: "register", email: email, password: password, completion: completion)
    }
    
    //ログインAPIを定義
    class func login(email: String, password: String, completion: @escaping ((Result, String?) -> ())) {
        AuthRequester.post(command: "login", email: email, password: password, completion: completion)
    }
    
    //postメソッドの定義
    private class func post(command: String, email: String, password: String, completion: @escaping ((Result, String?) -> ())) {
        
        let params = [
            "command": command,
            "email": email,
            "password": password
        ]
        ApiManager.post(params: params) { (result, data) in
            if result, let data = data as? Dictionary<String, Any> {
                let resultValue = Result(data["result"] as? String)
                let userId = data["userId"] as? String
                completion(resultValue, userId)
                return
            }
            completion(.networkError, nil)
        }
    }
}
