//
//  CategoryViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/15.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet private weak var scrollSegmentedContainer: UIView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    fileprivate var selectedCategoryIndex = Int(0)
    fileprivate weak var scrollSegmentedControl: ScrollSegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        let scrollSegmentedControl = UINib(nibName: "ScrollSegmentedControl", bundle: nil).instantiate(withOwner: self, options: nil).first as! ScrollSegmentedControl
        self.scrollSegmentedContainer.addSubview(scrollSegmentedControl)
        scrollSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        scrollSegmentedControl.topAnchor.constraint(equalTo: scrollSegmentedContainer.topAnchor).isActive = true
        scrollSegmentedControl.leadingAnchor.constraint(equalTo: scrollSegmentedContainer.leadingAnchor).isActive = true
        scrollSegmentedControl.trailingAnchor.constraint(equalTo: scrollSegmentedContainer.trailingAnchor).isActive = true
        scrollSegmentedControl.bottomAnchor.constraint(equalTo: scrollSegmentedContainer.bottomAnchor).isActive = true
        self.scrollSegmentedControl = scrollSegmentedControl
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.scrollView.subviews.flatMap{ $0 as? CategoryItemCollectionView }).isEmpty {
            self.initItems()
        }
    }
    

    private func initItems() {
        
        self.scrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        self.scrollSegmentedControl.set(titles: CategoryRequester.shared.dataList.map { $0.name }) { index in
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * self.scrollView.frame.size.width, y: 0), animated: true)
        }
        
        for i in 0..<CategoryRequester.shared.dataList.count {
            let frame = CGRect(origin: CGPoint(x: CGFloat(i) * self.scrollView.frame.size.width, y: 10),
                               size: self.scrollView.frame.size)
            let collectionView = UINib(nibName: "CategoryItemCollectionView", bundle: nil).instantiate(withOwner: self, options: nil).first as! CategoryItemCollectionView
            collectionView.frame = frame
            collectionView.setCategory(id: CategoryRequester.shared.dataList[i].id, callback: { [weak self] itemData in
                let itemDetailViewController = self?.viewController(identifier: "ItemDetailViewController") as! ItemDetailViewController
                itemDetailViewController.set(itemData: itemData)
                self?.stack(viewController: itemDetailViewController, animationType: .horizontal)
            })
            self.scrollView.addSubview(collectionView)
        }
        
        self.scrollView.contentSize = CGSize(width: CGFloat(CategoryRequester.shared.dataList.count) * self.scrollView.frame.size.width,
                                             height: self.scrollView.frame.size.height)
    }

    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}


extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        label.text = CategoryRequester.shared.dataList[indexPath.row].name
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        
        return CGSize(width: label.frame.size.width + 20, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryRequester.shared.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.configure(name: CategoryRequester.shared.dataList[indexPath.row].name, isSelected: self.selectedCategoryIndex == indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = CGFloat(indexPath.row) * self.scrollView.frame.size.width
        let offset = CGPoint(x: x, y: 0)
        self.scrollView.setContentOffset(offset, animated: true)
    }
}


extension CategoryViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.scrollSegmentedControl.didSelect(at: page)
    }
}
