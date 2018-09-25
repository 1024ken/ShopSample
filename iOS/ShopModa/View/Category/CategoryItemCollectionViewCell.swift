//
//  CategoryItemCollectionViewCell.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/15.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class CategoryItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var makerLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ImageStorage.shared.cancelRequest(imageView: self.itemImageView)
    }
    
    
    func configure(data: ItemData) {
        
        ImageStorage.shared.fetch(url: data.image, imageView: self.itemImageView)
        self.itemNameLabel.text = data.name
        self.makerLabel.text = data.maker
        self.priceLabel.text = String(price: data.price)
    }
}
