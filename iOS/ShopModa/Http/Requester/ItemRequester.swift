//
//  ItemRequester.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/10.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

struct ItemData {
    
    let id: String
    let name: String
    let kana: String
    let maker: String
    let price: Int
    let category: [String]
    let image: String
    let detail: String
    let colors: [String]
    let sizes: [String]
    let new: Bool
    let popular: Bool
    
    init?(data: Dictionary<String, Any>) {
        
        guard let id = data["id"] as? String else {
            return nil
        }
        self.id = id
        
        self.name = data["name"] as? String ?? ""
        self.kana = data["kana"] as? String ?? ""
        self.maker = data["maker"] as? String ?? ""
        self.price = data["price"] as? Int ?? 0
        self.category = (data["category"] as? [String] ?? [])
        self.image = data["image"] as? String ?? ""
        self.detail = data["detail"] as? String ?? ""
        self.colors = data["colors"] as? Array<String> ?? [String]()
        self.sizes = data["sizes"] as? Array<String> ?? [String]()
        self.new = (data["new"] as? String ?? "0") == "1"
        self.popular = (data["popular"] as? String ?? "0") == "1"
    }
}

class ItemRequester {
    
    static let shared = ItemRequester()
    
    var dataList = [ItemData]()
    
    func fetch(completion: @escaping ((Bool) -> ())) {
        
        self.dataList.removeAll()
        
        let params = ["command": "getItem"]
        ApiManager.post(params: params) { result, data in
            if let json = data as? Array<Any> {
                json.flatMap { $0 as? Dictionary<String, Any> }.forEach {
                    if let itemData = ItemData(data: $0) {
                        self.dataList.append(itemData)
                    }
                }
                completion(true)
                return
            }
            completion(false)
        }
    }
    
    func isExistItem(id: String) -> Bool {
        return self.dataList.contains { $0.id == id }
    }
    
    func filter(itemId: String) -> ItemData? {
        return self.dataList.filter { $0.id == itemId }.first
    }
    
    func filter(categoryId: String) -> [ItemData] {
        return self.dataList.filter { $0.category.contains(categoryId) }
    }
    
    func filterWithNew() -> [ItemData] {
        return self.dataList.filter { $0.new }
    }
    
    func filterWithPopular() -> [ItemData] {
        return self.dataList.filter { $0.popular }
    }
    
    func filter(text: String) -> [ItemData] {
        return self.dataList.filter { $0.name.contains(text) || $0.kana.contains(text) }
    }
}
