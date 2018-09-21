//
//  LoginViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/01/25.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBAction func didEndOnExitEmail(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndOnExitPassword(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTapLogin(_ sender: Any) {
        
        guard let email = self.emailTextField.text, let password = self.passwordTextField.text else {
            return
        }
        
        Loading.start()
        AuthRequester.login(email: email, password: password) { [weak self] result, userId in
            Loading.stop()
            
            switch(result) {
            case .ok:
                let saveData = SaveData.shared
                saveData.userId = userId ?? ""
                saveData.save()
                self?.pop(animationType: .vertical)
            case .inputError:
                self?.showAlert(title: "エラー", message: "入力内容に誤りがあります", actions: [AlertAction(title: "OK")])
            case .networkError:
                self?.showAlert(title: "ネットワークエラー", message: "ネットワーク設定をご確認ください", actions: [AlertAction(title: "OK")])
            case .error, .duplicated:
                self?.showAlert(title: "エラー", message: "ログインに失敗しました", actions: [AlertAction(title: "OK")])
            }
        }
    }
    
    @IBAction func onTapRegister(_ sender: Any) {
        
        let registerViewController = self.viewController(identifier: "RegisterViewController") as! RegisterViewController
        self.stack(viewController: registerViewController, animationType: .none)
    }
    
    @IBAction func onTapClose(_ sender: Any) {
        self.pop(animationType: .vertical)
    }
}

