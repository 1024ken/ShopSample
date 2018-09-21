//
//  String+Base64.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/27.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

extension String {
    
    func base64Encode() -> String? {
        let data = self.data(using: Constants.StringEncoding)
        return data?.base64EncodedString()
    }
    
    func base64Decode() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: Constants.StringEncoding)
        }
        return nil
    }
}
