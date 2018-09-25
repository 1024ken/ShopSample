//
//  FavoriteViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/08.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

enum FavoriteCellType {
    case title
    case item
    case news
    case noData
}

struct FavoriteCellData {
    let type: FavoriteCellType
    let data: Any?
}


class FavoriteViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate var cellDatas = [FavoriteCellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        cellDatas.append(FavoriteCellData(type: .title, data: "Items"))
        let favoriteItems = SaveData.shared.favoriteItemIds.flatMap { ItemRequester.shared.filter(itemId: $0) }
        if favoriteItems.count > 0 {
            favoriteItems.forEach { self.cellDatas.append(FavoriteCellData(type: .item, data: $0)) }
        } else {
            self.cellDatas.append(FavoriteCellData(type: .noData, data: nil))
        }
        cellDatas.append(FavoriteCellData(type: .title, data: "News"))
        let favoriteNews = SaveData.shared.favoriteNewsIds.flatMap { NewsRequester.shared.filter(newsId: $0) }
        if favoriteNews.count > 0 {
            favoriteNews.forEach { self.cellDatas.append(FavoriteCellData(type: .news, data: $0)) }
        } else {
            self.cellDatas.append(FavoriteCellData(type: .noData, data: nil))
        }
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}


extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = self.cellDatas[indexPath.row]
        switch cellData.type {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTitleTableViewCell", for: indexPath) as! FavoriteTitleTableViewCell
            cell.configure(title: cellData.data as! String)
            return cell
        case .item:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteItemTableViewCell", for: indexPath) as! FavoriteItemTableViewCell
            cell.configure(data: cellData.data as! ItemData)
            return cell
        case .news:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteNewsTableViewCell", for: indexPath) as! FavoriteNewsTableViewCell
            cell.configure(data: cellData.data as! NewsData)
            return cell
        case .noData:
            return tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellData = self.cellDatas[indexPath.row]
        switch cellData.type {
        case .item:
            let itemData = cellData.data as! ItemData
            let itemDetailViewController = self.viewController(identifier: "ItemDetailViewController") as! ItemDetailViewController
            itemDetailViewController.set(itemData: itemData)
            self.stack(viewController: itemDetailViewController, animationType: .horizontal)
        case .news:
            let newsData = cellData.data as! NewsData
            let newsDetailViewController = self.viewController(identifier: "NewsDetailViewController") as! NewsDetailViewController
            newsDetailViewController.set(newsData: newsData)
            self.stack(viewController: newsDetailViewController, animationType: .horizontal)
        default:
            break
        }
    }
}
