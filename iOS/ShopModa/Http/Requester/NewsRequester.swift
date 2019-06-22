//
//  NewsRequester.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/11.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

//ニュースデータを定義
struct NewsData {
    
    let id: String
    let title: String
    let body: String
    let image: String
    let presenter: String
    let date: Date?
    
    init?(data: Dictionary<String, Any>) {
        
        guard let id = data["id"] as? String else {
            return nil
        }
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.body = data["body"] as? String ?? ""
        self.image = data["image"] as? String ?? ""
        self.presenter = data["presenter"] as? String ?? ""
        self.date = (data["time"] as? String ?? "").toDate()
    }
}

//ニュース情報を取得するためのAPIを呼び出す
class NewsRequester {
    
    static let shared = NewsRequester()
    
    var dataList = [NewsData]()
    
    func fetch(completion: @escaping ((Bool) -> ())) {
        
        self.dataList.removeAll()
        
        let params = [
            "command": "getNews"
        ]
        ApiManager.post(params: params) { result, data in
            if let json = data as? Array<Any> {
                json.compactMap { $0 as? Dictionary<String, Any> }.forEach {
                    if let newsData = NewsData(data: $0) {
                        self.dataList.append(newsData)
                    }
                }
                completion(true)
                return
            }
            completion(false)
        }
    }
    
    func filter(newsId: String) -> NewsData? {
        return self.dataList.filter { $0.id == newsId }.first
    }
    
    func unreadCount() -> Int {
        return self.dataList.filter { !SaveData.shared.readNewsIds.contains($0.id) }.count
    }
}
