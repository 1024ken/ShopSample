//
//  NewsViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/10.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}


extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsRequester.shared.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.configure(data: NewsRequester.shared.dataList[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsData = NewsRequester.shared.dataList[indexPath.row]
        
        let newsDetailViewController = self.viewController(identifier: "NewsDetailViewController") as! NewsDetailViewController
        newsDetailViewController.set(newsData: newsData)
        self.stack(viewController: newsDetailViewController, animationType: .horizontal)
        
        let saveData = SaveData.shared
        if !saveData.readNewsIds.contains(newsData.id) {
            saveData.readNewsIds.append(newsData.id)
            saveData.save()
        }
    }
}
