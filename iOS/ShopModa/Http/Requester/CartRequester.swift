//
//  CartRequester.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/11.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

//カートデータを定義
struct CartData {
    
    let itemId: String
    let itemInfo: String
    var number: Int
    
    init?(data: Dictionary<String, Any>) {
        
        guard let itemId = data["itemId"] as? String else {
            return nil
        }
        self.itemId = itemId
        
        self.itemInfo = data["itemInfo"] as? String ?? ""
        self.number = Int(data["number"] as? String ?? "") ?? 0
    }
    
    init(itemId: String, itemInfo: String, number: Int) {
        self.itemId = itemId
        self.itemInfo = itemInfo
        self.number = number
    }
    
    func toParam() -> String {
        return itemId + ":" + "\(number)"
    }
}

class CartRequester {
    
    //カート情報を取得するためのAPIを呼び出す
    class func fetch(userId: String, completion: @escaping ((Bool, [CartData]?) -> ())) {
        
        let params = [
            "command": "getCart",
            "userId": userId
        ]
        ApiManager.post(params: params) { result, data in
            if let json = data as? Array<Any> {
                var dataList = [CartData]()
                json.flatMap { $0 as? Dictionary<String, Any> }.forEach {
                    if let cartData = CartData(data: $0) {
                        dataList.append(cartData)
                    }
                }
                completion(true, dataList)
                return
            }
            completion(false, nil)
        }
    }
    
    //カート情報を加えるためのAPIを呼び出す
    class func addCart(userId: String, data: CartData, completion: @escaping ((Bool) -> ())) {
        
        CartRequester.fetch(userId: userId) { result, cartData in
            if result, let cartData = cartData {
                var addedCartData = cartData
                if let index = (addedCartData.index { $0.itemId == data.itemId }) {
                    addedCartData[index].number += data.number
                } else {
                    addedCartData.append(data)
                }
                CartRequester.setCart(userId: userId, cartDatas: addedCartData, completion: completion)
                return
            }
            completion(false)
        }
    }
    
    //カート情報を更新するためのAPIを呼び出す
    class func setCart(userId: String, cartDatas: [CartData], completion: @escaping ((Bool) -> ())) {
        
        let params = [
            "command": "setCart",
            "userId": userId,
            "items": (cartDatas.map { $0.toParam() }).joined(separator: ",")
        ]
        ApiManager.post(params: params) { result, data in
            if let json = data as? Dictionary<String, Any> {
                if let resultValue = (json["result"] as? String), resultValue == "0" {
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
    
    //カート情報を注文するためのAPIを呼び出す
    class func purchase(userId: String, completion: @escaping ((Bool) -> ())) {
        
        let params = [
            "command": "purchase",
            "userId": userId
        ]
        ApiManager.post(params: params) { result, data in
            if let json = data as? Dictionary<String, Any> {
                if let resultValue = (json["result"] as? String), resultValue == "0" {
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
}
