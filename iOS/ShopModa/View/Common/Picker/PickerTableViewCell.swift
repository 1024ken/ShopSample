//
//  PickerTableViewCell.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/06.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var selectedImageView: UIImageView!
    @IBOutlet private weak var dataLabel: UILabel!
    
    
    func configure(title: String, isSelected: Bool) {
        
        self.selectedImageView.isHidden = !isSelected
        self.dataLabel.text = title
    }
}
