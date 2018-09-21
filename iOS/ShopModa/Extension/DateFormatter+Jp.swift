//
//  DateFormatter+Jp.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/02.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    convenience init(dateFormat: String) {
        self.init()
        
        self.locale = Locale(identifier: "ja_JP")
        self.calendar = Calendar(identifier: .gregorian)
        self.dateFormat = dateFormat
    }
}
