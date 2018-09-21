//
//  ItemDetailViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/02.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var makerLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var colorLabel: UILabel!
    
    private var itemData: ItemData!
    private var selectedSizeIndex = 0
    private var selectedColorIndex = 0
    
    func set(itemData: ItemData) {
        self.itemData = itemData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initContents()
        self.setFavoriteState()
    }
    
    private func initContents() {
        
        ImageStorage.shared.fetch(url: self.itemData.image, imageView: self.itemImageView)
        self.nameLabel.text = self.itemData.name
        self.makerLabel.text = self.itemData.maker
        self.priceLabel.text = String(price: self.itemData.price)
        self.detailLabel.text = self.itemData.detail
        
        if self.itemData.sizes.count > self.selectedSizeIndex {
            self.sizeLabel.text = self.itemData.sizes[self.selectedSizeIndex]
        }
        if self.itemData.colors.count > self.selectedColorIndex {
            self.colorLabel.text = self.itemData.colors[self.selectedColorIndex]
        }
    }
    
    private func setFavoriteState() {
        
        let saveData = SaveData.shared
        if let _ = saveData.favoriteItemIds.index(of: self.itemData.id) {
            self.favoriteButton.setBackgroundImage(UIImage(named: "favoriteOn"), for: .normal)
        } else {
            self.favoriteButton.setBackgroundImage(UIImage(named: "favoriteOff"), for: .normal)
        }
    }
    
    @IBAction func onTapSize(_ sender: Any) {
        
        let picker = self.viewController(identifier: "PickerViewController") as! PickerViewController
        picker.set(title: "Size", dataArray: self.itemData.sizes, defaultIndex: self.selectedSizeIndex) { [weak self] index in
            self?.selectedSizeIndex = index
            if self?.itemData.sizes.count ?? 0 > index {
                self?.sizeLabel.text = self?.itemData.sizes[index]
            }
        }
        self.stack(viewController: picker, animationType: .none)
    }
    
    @IBAction func onTapColor(_ sender: Any) {
        
        let picker = self.viewController(identifier: "PickerViewController") as! PickerViewController
        picker.set(title: "Color", dataArray: self.itemData.colors, defaultIndex: self.selectedColorIndex) { [weak self] index in
            self?.selectedColorIndex = index
            if self?.itemData.colors.count ?? 0 > index {
                self?.colorLabel.text = self?.itemData.colors[index]
            }
        }
        self.stack(viewController: picker, animationType: .none)
    }
    
    @IBAction func onTapAddCart(_ sender: Any) {
        
        let saveData = SaveData.shared
        if saveData.isLoggedIn() {
            let itemInfo = self.createItemInfo()
            let cartData = CartData(itemId: self.itemData.id, itemInfo: itemInfo, number: 1)
            CartRequester.addCart(userId: saveData.userId, data: cartData, completion: { [weak self] result in
                if result {
                    let childViewController = self?.topViewController()?.childViewControllers.first
                    let cartViewController = self?.viewController(identifier: "CartViewController") as! CartViewController
                    self?.topViewController()?.stack(viewController: cartViewController, animationType: .vertical, completion: {
                        childViewController?.pop(animationType: .none)
                    })
                } else {
                    self?.showAlert(title: "エラー", message: "通信に失敗しました", actions: [AlertAction(title: "OK")])
                }
            })
        } else {
            let loginViewController = self.viewController(identifier: "LoginViewController")
            self.stack(viewController: loginViewController, animationType: .horizontal)
        }
    }
    
    private func createItemInfo() -> String {
        
        var itemInfo = ""
        
        itemInfo += "Size "
        if self.itemData.sizes.count > self.selectedSizeIndex {
            itemInfo += self.itemData.sizes[self.selectedSizeIndex]
        }
        
        itemInfo += " / "
        
        itemInfo += "Color "
        if self.itemData.colors.count > self.selectedColorIndex {
            itemInfo += self.itemData.colors[self.selectedColorIndex]
        }
        
        return itemInfo
    }
    
    @IBAction func onTapFavorite(_ sender: Any) {
        
        let saveData = SaveData.shared
        if let index = saveData.favoriteItemIds.index(of: self.itemData.id) {
            saveData.favoriteItemIds.remove(at: index)
        } else {
            saveData.favoriteItemIds.append(self.itemData.id)
        }
        saveData.save()
        
        self.setFavoriteState()
        self.favoriteButton.expand()
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}
