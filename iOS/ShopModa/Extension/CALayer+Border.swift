//
//  ALayer+Border.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/25.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//


import UIKit

extension CALayer {
    
    @objc var borderUIColor: UIColor? {
        get {
            return borderColor == nil ? nil : UIColor(cgColor: borderColor!)
        }
        set {
            borderColor = newValue == nil ? nil : newValue!.cgColor
        }
    }
}
