//
//  HistoryTableViewCell.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/24.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//


import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNamesLabel: UILabel!
    @IBOutlet private weak var totalCountLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ImageStorage.shared.cancelRequest(imageView: self.itemImageView)
    }
    
    func configure(data: HistoryData) {
        
        if let firstItemId = data.items.first?.itemId,
            let firstItem = ItemRequester.shared.filter(itemId: firstItemId) {
            ImageStorage.shared.fetch(url: firstItem.image, imageView: self.itemImageView)
        } else {
            self.itemImageView.image = nil
        }
        
        let itemDatas = (data.items.flatMap { ItemRequester.shared.filter(itemId: $0.itemId) })
        self.itemNamesLabel.text = itemDatas.map { $0.name }.joined(separator: ", ")
        
        var totalCount = 0
        data.items.forEach { totalCount += $0.number }
        self.totalCountLabel.text = "総数: \(totalCount)"
        
        var totalPrice = 0
        data.items.forEach {
            if let itemData = ItemRequester.shared.filter(itemId: $0.itemId) {
                totalPrice += $0.number * itemData.price
            }
        }
        self.totalPriceLabel.text = String(price: totalPrice)
    }
}
