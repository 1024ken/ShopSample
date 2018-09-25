//
//  MenuViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/01/22.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet private weak var unreadNewsLabel: UILabel!
    @IBOutlet private weak var deliverySettingButton: UIButton!
    @IBOutlet private weak var creditCardButton: UIButton!
    @IBOutlet private weak var historyButton: UIButton!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var loginIconImageView: UIImageView!
    @IBOutlet private weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var closeButtonWidthConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLoginState()
        
        let unreadNewsCount = NewsRequester.shared.unreadCount()
        if unreadNewsCount > 0 {
            self.unreadNewsLabel.text = "\(NewsRequester.shared.unreadCount())"
        } else {
            self.unreadNewsLabel.isHidden = true
        }
        
        self.containerWidthConstraint.constant = UIScreen.main.bounds.size.width - self.closeButtonWidthConstraint.constant
        self.closeButtonWidthConstraint.constant = UIScreen.main.bounds.size.width
    }
    
    
    private func setLoginState() {
        
        let isLoggedIn = SaveData.shared.isLoggedIn()
        
        self.loginIconImageView.image = isLoggedIn ? UIImage(named: "logout") : UIImage(named: "login")
        self.loginLabel.text = isLoggedIn ? "Log out" : "Log in"
        
        self.deliverySettingButton.isEnabled = isLoggedIn
        self.creditCardButton.isEnabled = isLoggedIn
        self.historyButton.isEnabled = isLoggedIn
        
        self.deliverySettingButton.backgroundColor = isLoggedIn ? .clear : .disableMenu
        self.creditCardButton.backgroundColor = isLoggedIn ? .clear : .disableMenu
        self.historyButton.backgroundColor = isLoggedIn ? .clear : .disableMenu
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.closeButtonWidthConstraint.constant = 100
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func onTapNews(_ sender: Any) {
        let newsViewController = self.viewController(identifier: "NewsViewController")
        self.stackOnParent(newsViewController)
    }
    
    @IBAction func onTapFavorite(_ sender: Any) {
        let favoriteViewController = self.viewController(identifier: "FavoriteViewController")
        self.stackOnParent(favoriteViewController)
    }
    
    @IBAction func onTapAddressEdit(_ sender: Any) {
        if SaveData.shared.isLoggedIn() {
            let userInformationViewController = self.viewController(identifier: "AddressEditViewController")
            self.stackOnParent(userInformationViewController)
        }
    }
    
    @IBAction func onTapCreditCardEdit(_ sender: Any) {
        if SaveData.shared.isLoggedIn() {
            let creditCardEditViewController = self.viewController(identifier: "CreditCardEditViewController")
            self.stackOnParent(creditCardEditViewController)
        }
    }
    
    @IBAction func onTapHistory(_ sender: Any) {
        if SaveData.shared.isLoggedIn() {
            let historyViewController = self.viewController(identifier: "HistoryViewController")
            self.stackOnParent(historyViewController)
        }
    }
    
    @IBAction func onTapLogin(_ sender: Any) {
        
        if !SaveData.shared.isLoggedIn() {
            let loginViewController = self.viewController(identifier: "LoginViewController")
            self.stackOnParent(loginViewController)
        } else {
            let logoutAction = AlertAction(title: "はい", action: { [weak self] in
                let saveData = SaveData.shared
                saveData.userId = ""
                saveData.save()
                
                self?.close()
            })
            let cancelAction = AlertAction(title: "キャンセル")
            self.showAlert(title: "確認", message: "ログアウトしますか？", actions: [logoutAction, cancelAction])
        }
    }
    
    @IBAction func onTapClose(_ sender: Any) {
        self.close()
    }
    
    @IBAction func onTapBackground(_ sender: Any) {
        self.close()
    }
    
    
    private func stackOnParent(_ viewController: UIViewController) {
        self.parent?.stack(viewController: viewController, animationType: .none)
        self.parent?.view.bringSubview(toFront: self.view)
        self.close()
    }
    
    private func close() {
        
        self.closeButtonWidthConstraint.constant = UIScreen.main.bounds.size.width
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                self?.pop(animationType: .none)
        })
    }
}
