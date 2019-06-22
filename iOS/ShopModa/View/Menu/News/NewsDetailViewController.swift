//
//  NewsDetailViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/10.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet private weak var presenterLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    private var newsData: NewsData!
    
    
    func set(newsData: NewsData) {
        self.newsData = newsData
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenterLabel.text = self.newsData.presenter
        
        if let date = self.newsData.date {
            self.dateLabel.text = String(date: date)
        } else {
            self.dateLabel.text = ""
        }
        
        ImageStorage.shared.fetch(url: self.newsData.image, imageView: self.newsImageView)
        self.newsTitleLabel.text = self.newsData.title
        self.bodyLabel.text = self.newsData.body
        
        self.setFavoriteState()
    }
    
    private func setFavoriteState() {
        
        let saveData = SaveData.shared
        if let _ = saveData.favoriteNewsIds.firstIndex(of: self.newsData.id) {
            self.favoriteButton.setBackgroundImage(UIImage(named: "favoriteOn"), for: .normal)
        } else {
            self.favoriteButton.setBackgroundImage(UIImage(named: "favoriteOff"), for: .normal)
        }
    }
    
    @IBAction func onTapFavorite(_ sender: Any) {
        
        let saveData = SaveData.shared
        if let index = saveData.favoriteNewsIds.firstIndex(of: self.newsData.id) {
            saveData.favoriteNewsIds.remove(at: index)
        } else {
            saveData.favoriteNewsIds.append(self.newsData.id)
        }
        saveData.save()
        
        self.setFavoriteState()
        self.favoriteButton.expand()
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}
