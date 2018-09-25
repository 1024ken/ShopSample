//
//  HistoryViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/24.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noDataView: UIView!
    
    fileprivate var historyList = [HistoryData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noDataView.isHidden = true
        
        let saveData = SaveData.shared
        if saveData.isLoggedIn() {
            
            Loading.start()
            
            HistoryRequester.fetch(userId: saveData.userId, completion: { [weak self] result, dataList in
                Loading.stop()
                
                if result, let dataList = dataList {
                    self?.historyList = dataList
                    self?.tableView.reloadData()
                    self?.noDataView.isHidden = dataList.count > 0
                }
            })
        }
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}


extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.configure(data: self.historyList[indexPath.row])
        return cell
    }
}
