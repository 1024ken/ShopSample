//
//  ImageStorage.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/07.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

private struct ImageStorageData {
    
    let url: String
    let image: UIImage
}


private struct ImageRequestData {
    
    let url: String
    let imageView: UIImageView
}


class ImageStorage {
    
    static let shared = ImageStorage()
    
    private var imageList = [ImageStorageData]()
    private var requestList = [ImageRequestData]()
    
    func fetch(url: String, imageView: UIImageView) {
        
        if let image = (self.imageList.filter { $0.url == url }).first?.image {
            imageView.image = image
            return
        }
        imageView.image = nil
        
        self.cancelRequest(imageView: imageView)
        
        let request = ImageRequestData(url: url, imageView: imageView)
        self.requestList.append(request)
        
        HttpManager.get(url: url) { [weak self] (result, data) in
            
            guard let requestData = (self?.requestList.filter{ $0.url == url })?.first else {
                return
            }
            
            var resultImage: UIImage?
            if result, let data = data, let image = UIImage(data: data) {
                resultImage = image
            } else {
                resultImage = UIImage(named: "noImage")
            }
            let storageData = ImageStorageData(url: url, image: resultImage!)
            self?.imageList.append(storageData)
            self?.cancelRequest(imageView: requestData.imageView)
            requestData.imageView.image = resultImage!
        }
    }
    
    func query(url: String) -> UIImage? {
        return (self.imageList.filter { $0.url == url }).first?.image
    }
    
    func cancelRequest(imageView: UIImageView) {
        
        var sameIndexes = [Int]()
        for i in 0..<self.requestList.count {
            if self.requestList[i].imageView == imageView {
                sameIndexes.append(i)
            }
        }
        sameIndexes.forEach{ self.requestList.remove(at: $0) }
    }
}
