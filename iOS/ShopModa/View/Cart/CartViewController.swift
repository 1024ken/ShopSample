//
//  CartViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/18.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var noDataView: UIView!
    
    fileprivate var cartDatas = [CartData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchCartData()
    }
    
    
    private func fetchCartData() {
        
        Loading.start()
        
        CartRequester.fetch(userId: SaveData.shared.userId, completion: { [weak self] result, dataList in
            Loading.stop()
            
            if result, let dataList = dataList {
                self?.cartDatas = dataList.flatMap { ItemRequester.shared.isExistItem(id: $0.itemId) ? $0 : nil }
                self?.tableView.reloadData()
                self?.refreshTotalPrice()
                self?.noDataView.isHidden = dataList.count > 0
            } else {
                let retryAction = AlertAction(title: "リトライ", action: { [weak self] in
                    self?.fetchCartData()
                })
                let cancelAction = AlertAction(title: "キャンセル", action: { [weak self] in
                    self?.pop(animationType: .vertical)
                })
                self?.showAlert(title: "エラー", message: "通信に失敗しました", actions: [retryAction, cancelAction])
            }
        })
    }
    
    fileprivate func refreshTotalPrice() {
        
        var price = 0
        self.cartDatas.forEach { cartData in
            if let itemData = ItemRequester.shared.filter(itemId: cartData.itemId) {
                price += itemData.price * cartData.number
            }
        }
        self.totalPriceLabel.text = String(price: price)
    }
    
    @IBAction func onTapNext(_ sender: Any) {
        CartRequester.setCart(userId: SaveData.shared.userId, cartDatas: self.cartDatas) { result in
            if result {
                let addressEditViewController = self.viewController(identifier: "AddressEditViewController") as! AddressEditViewController
                self.stack(viewController: addressEditViewController, animationType: .horizontal)
            } else {
                self.showAlert(title: "エラー", message: "通信に失敗しました", actions: [AlertAction(title: "OK")])
            }
        }
    }
    
    @IBAction func onTapClose(_ sender: Any) {
        self.pop(animationType: .vertical)
    }
}


extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cartDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.configure(data: self.cartDatas[indexPath.row], didChangeNumber: { [weak self] increase in
            guard var number = self?.cartDatas[indexPath.row].number else {
                return
            }
            number += (increase ? 1 : -1)
            if number <= 0 {
                number = 1
            }
            self?.cartDatas[indexPath.row].number = number
            tableView.reloadData()
            self?.refreshTotalPrice()
        })
        return cell
    }
}
