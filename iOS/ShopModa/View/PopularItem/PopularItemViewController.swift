//
//  PopularItemViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/12.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class PopularItemViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    fileprivate var itemList = ItemRequester.shared.filterWithPopular()
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}


extension PopularItemViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularItemCollectionViewCell", for: indexPath) as! PopularItemCollectionViewCell
        cell.configure(data: self.itemList[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width / 2,
                      height: UIScreen.main.bounds.size.width / 2 + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let itemDetailViewController = self.viewController(identifier: "ItemDetailViewController") as! ItemDetailViewController
        itemDetailViewController.set(itemData: self.itemList[indexPath.row])
        self.stack(viewController: itemDetailViewController, animationType: .horizontal)
    }
}
