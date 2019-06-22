//
//  CategoryRequester.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/10.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

//カテゴリーデータを定義
struct CategoryData {
    
    let id: String
    let name: String
    
    init?(data: Dictionary<String, Any>) {
        guard let id = data["id"] as? String else {
            return nil
        }
        self.id = id
        
        self.name = data["name"] as? String ?? ""
    }
}

class CategoryRequester {
    
    static let shared = CategoryRequester()
    
    var dataList = [CategoryData]()
    
    //カテゴリー情報を保存するためのAPIを呼び出す
    func fetch(completion: @escaping ((Bool) -> ())) {
        
        self.dataList.removeAll()
        
        let params = ["command": "getCategory"]
        ApiManager.post(params: params) { result, data in
            if let json = data as? Array<Any> {
                json.compactMap { $0 as? Dictionary<String, Any> }.forEach {
                    if let categoryData = CategoryData(data: $0) {
                        self.dataList.append(categoryData)
                    }
                }
                completion(true)
                return
            }
            completion(false)
        }
    }
}
