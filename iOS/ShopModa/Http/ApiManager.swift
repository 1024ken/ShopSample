//
//  ApiManager.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/01/28.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

class ApiManager {
    
    //WebサーバーとAPI通信を行う
    class func post(params: [String: String]?, completion: @escaping ((Bool, Any?) -> ())) {
        
        //受信されたデータのJSON解析を行う
        HttpManager.post(url: Constants.ServerUrl, params: params) { result, data in
            if result, let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    completion(true, json)
                    return
                } catch {}
            }
            completion(false, nil)
        }
    }
}
