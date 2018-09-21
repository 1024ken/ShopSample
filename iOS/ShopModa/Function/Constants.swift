//
//  Constants.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/07.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//


import Foundation

struct Constants {
    static let HttpTimeOutInterval = TimeInterval(10)
    static let ServerUrl = "https://leapfrog.sakura.ne.jp/samples/shop_moda/srv.php"
    static let StringEncoding = String.Encoding.utf8
    
    struct UserDefaultsKey {
        
        static let UserId = "UserId"
        static let favoriteItemIds = "FavoriteItemIds"
        static let favoriteNewsIds = "FavoriteNewsIds"
        static let readNewsIds = "ReadNewsIds"
    }
}
