//
//  NewItemViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/01/25.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate var itemList = ItemRequester.shared.filterWithNew()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}

extension NewItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewItemTableViewCell", for: indexPath) as! NewItemTableViewCell
        cell.configure(data: self.itemList[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemDetailViewController = self.viewController(identifier: "ItemDetailViewController") as! ItemDetailViewController
        itemDetailViewController.set(itemData: self.itemList[indexPath.row])
        self.stack(viewController: itemDetailViewController, animationType: .horizontal)
    }
}
