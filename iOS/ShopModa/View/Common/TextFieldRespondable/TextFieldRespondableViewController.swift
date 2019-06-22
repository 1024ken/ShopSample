//
//  TextFieldRespondableViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/03/02.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class TextFieldRespondableViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveObserver),
            name: UITextField.textDidChangeNotification,
            object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UITextField.textDidChangeNotification,
            object: nil)
    }
    
    
    @objc func didReceiveObserver(notification: Notification) {
        self.textFieldDidChange()
    }
    
    func textFieldDidChange() {}
}
