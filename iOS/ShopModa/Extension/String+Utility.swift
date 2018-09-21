//
//  String+Utility.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/27.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

extension String {
    
    init?(date: Date) {
        
        let current = Date()
        
        let yearFormatter = DateFormatter(dateFormat: "yyyy")
        if yearFormatter.string(from: date) != yearFormatter.string(from: current) {
            self = DateFormatter(dateFormat: "yyyy/MM/dd HH:mm").string(from: date)
            return
        }
        let dayFormatter = DateFormatter(dateFormat: "yyyyMMdd")
        if dayFormatter.string(from: date) != dayFormatter.string(from: current) {
            self = DateFormatter(dateFormat: "MM/dd HH:mm").string(from: date)
            return
        }
        self = DateFormatter(dateFormat: "HH:mm").string(from: date)
    }
    
    func toDate() -> Date? {
        
        return DateFormatter(dateFormat: "yyyyMMddHHmmss").date(from: self)
    }
    
    init(price: Int) {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        self = (formatter.string(from: NSNumber(value: price)) ?? "") + "円"
    }
}
