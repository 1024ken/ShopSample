//
//  RegisterViewController.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/01/25.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

class RegisterViewController: TextFieldRespondableViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var emailAvailableImageView: UIImageView!
    @IBOutlet private weak var passwordAvailableImageView: UIImageView!
    @IBOutlet private weak var passwordConfirmAvailableImageView: UIImageView!
    @IBOutlet private weak var containerVerticalConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFieldDidChange()
        
        self.containerVerticalConstraint.constant = UIScreen.main.bounds.size.height / 2 + self.containerHeightConstraint.constant / 2
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.containerVerticalConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 4,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    override func textFieldDidChange() {
        
        guard let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            let passwordConfirm = self.passwordConfirmTextField.text else {
                return
        }
        let emailAvailable = email.isAvailableEmail()
        let passwordAvailable = password.isAvailablePassword()
        let passwordConfirmAvailable = passwordConfirm.isAvailablePassword() && password == passwordConfirm
        
        self.emailAvailableImageView.image = emailAvailable ? UIImage(named: "check") : UIImage(named: "error")
        self.passwordAvailableImageView.image = passwordAvailable ? UIImage(named: "check") : UIImage(named: "error")
        self.passwordConfirmAvailableImageView.image = passwordConfirmAvailable ? UIImage(named: "check") : UIImage(named: "error")
    }
    
    @IBAction func didEndOnExitEmail(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndOnExitPassword(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndOnExitPasswordConfirm(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTapRegister(_ sender: Any) {
        
        guard let email = self.emailTextField.text, let password = self.passwordTextField.text else {
            return
        }
        
        Loading.start()
        
        AuthRequester.register(email: email, password: password) { [weak self] result, userId in
            Loading.stop()
            
            switch(result) {
            case .ok:
                let saveData = SaveData.shared
                saveData.userId = userId ?? ""
                saveData.save()
                self?.close(completion: { [weak self] in
                    if let loginViewController = self?.parent as? LoginViewController {
                        loginViewController.pop(animationType: .none)
                    }
                })
            case .duplicated:
                self?.showAlert(title: "エラー", message: "登録済みのユーザーIDです", actions: [AlertAction(title: "OK")])
            case .inputError:
                self?.showAlert(title: "エラー", message: "入力内容が不正です", actions: [AlertAction(title: "OK")])
            case .networkError:
                self?.showAlert(title: "ネットワークエラー", message: "ネットワーク設定をご確認ください", actions: [AlertAction(title: "OK")])
            case .error:
                self?.showAlert(title: "エラー", message: "新規登録に失敗しました", actions: [AlertAction(title: "OK")])
            }
        }
    }
    
    @IBAction func onTapClose(_ sender: Any) {
        self.close { 
            self.pop(animationType: .none)
        }
    }
    
    private func close(completion: @escaping (() -> ())) {
        
        self.containerVerticalConstraint.constant = UIScreen.main.bounds.size.height / 2 + self.containerHeightConstraint.constant / 2
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { _ in
            completion()
        }
    }
}
