//
//  SpacingLabel.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/20.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class SpacingLabel: UILabel {
    
    @IBInspectable var lineHeight: CGFloat = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setSpace(self.text)
    }
    
    
    override var text: String? {
        didSet {
            self.setSpace(text)
        }
    }
    
    
    private func setSpace(_ text: String?) {
        
        guard let text = text else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = self.lineHeight
        paragraphStyle.maximumLineHeight = self.lineHeight
        paragraphStyle.alignment = self.textAlignment
        self.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
}
