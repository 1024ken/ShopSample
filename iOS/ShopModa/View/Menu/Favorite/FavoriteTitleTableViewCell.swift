//
//  FavoriteTitleTableViewCell.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/08.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class FavoriteTitleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var favoriteTitleLabel: UILabel!
    
    
    func configure(title: String) {
        self.favoriteTitleLabel.text = title
    }
}
