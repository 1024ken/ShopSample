//
//  SaveData.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/07.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

class SaveData {
    
    static let shared = SaveData()
    
    var userId = ""
    var favoriteItemIds = [String]()
    var favoriteNewsIds = [String]()
    var readNewsIds = [String]()
    
    init() {
        let userDefaults = UserDefaults()
        self.userId = userDefaults.string(forKey: Constants.UserDefaultsKey.UserId) ?? ""
        self.favoriteItemIds = userDefaults.stringArray(forKey: Constants.UserDefaultsKey.favoriteItemIds) ?? [String]()
        self.favoriteNewsIds = userDefaults.stringArray(forKey: Constants.UserDefaultsKey.favoriteNewsIds) ?? [String]()
        self.readNewsIds = userDefaults.stringArray(forKey: Constants.UserDefaultsKey.readNewsIds) ?? [String]()
    }
    
    func save() {
        
        let userDefaults = UserDefaults()
        userDefaults.set(self.userId, forKey: Constants.UserDefaultsKey.UserId)
        userDefaults.set(self.favoriteItemIds, forKey: Constants.UserDefaultsKey.favoriteItemIds)
        userDefaults.set(self.favoriteNewsIds, forKey: Constants.UserDefaultsKey.favoriteNewsIds)
        userDefaults.set(self.readNewsIds, forKey: Constants.UserDefaultsKey.readNewsIds)
        userDefaults.synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return self.userId.characters.count > 0
    }
}
