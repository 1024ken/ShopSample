
import UIKit

class CreditCardEditViewController: TextFieldRespondableViewController {
    
    @IBOutlet private weak var numberTextField: UITextField!
    @IBOutlet private weak var expireTextField: UITextField!
    @IBOutlet private weak var cvcTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Loading.start()
        
        CreditCardRequester.fetch(userId: SaveData.shared.userId) { [weak self] (result, creditCardData) in
            Loading.stop()
            
            if result, let creditCardData = creditCardData {
                self?.numberTextField.text = creditCardData.number
                self?.expireTextField.text = creditCardData.expire
                self?.cvcTextField.text = creditCardData.cvc
                self?.nameTextField.text = creditCardData.name
                
                self?.textFieldDidChange()
            } else {
                self?.showError("通信に失敗しました")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = self.parent as? AddressEditViewController {
            self.saveButton.setTitle("注文を確定する", for: .normal)
        }
    }
    
    override func textFieldDidChange() {
        
        if let number = self.numberTextField.text {
            var formattedNumber = number.replacingOccurrences(of: " ", with: "")
            if formattedNumber.characters.count >= 13 {
                formattedNumber.insert(" ", at: formattedNumber.index(formattedNumber.startIndex, offsetBy: 12))
            }
            if formattedNumber.characters.count >= 9 {
                formattedNumber.insert(" ", at: formattedNumber.index(formattedNumber.startIndex, offsetBy: 8))
            }
            if formattedNumber.characters.count >= 5 {
                formattedNumber.insert(" ", at: formattedNumber.index(formattedNumber.startIndex, offsetBy: 4))
            }
            self.numberTextField.text = formattedNumber
        }
        
        if var expire = self.expireTextField.text {
            if expire.isOnlyNumber() {
                var formattedExpire = expire.replacingOccurrences(of: " ", with: "")
                formattedExpire = formattedExpire.replacingOccurrences(of: "/", with: "")
                if formattedExpire.characters.count >= 3 {
                    formattedExpire.insert(contentsOf: [" ", "/" , " "], at: formattedExpire.index(formattedExpire.startIndex, offsetBy: 2))
                    expire = formattedExpire
                }
            }
            if expire.characters.count >= 8 {
                expire = String(expire.prefix(8))
            }
            self.expireTextField.text = expire
        }
    }
    
    @IBAction func didEndEditNumber(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndEditExpire(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndEditCvc(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndEditName(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTapSave(_ sender: Any) {
        
        guard let creditCardDate = self.inputData() else {
            return
        }
        
        Loading.start()
        
        CreditCardRequester.set(userId: SaveData.shared.userId, creditCardData: creditCardDate) { [weak self] result in
            Loading.stop()
            
            if result {
                if let _ = self?.parent as? AddressEditViewController {
                    self?.purchase()
                } else {
                    let action = AlertAction(title: "閉じる", action: { [weak self] in
                        self?.pop(animationType: .horizontal)
                    })
                    self?.showAlert(title: "確認", message: "更新しました", actions: [action])
                }
            } else {
                let action = AlertAction(title: "OK")
                self?.showAlert(title: "エラー", message: "通信に失敗しました", actions: [action])
            }
        }
    }
    
    private func inputData() -> CreditCardData? {
        
        guard let number = self.numberTextField.text?.replacingOccurrences(of: " ", with: ""),
            let expire = self.expireTextField.text,
            let cvc = self.cvcTextField.text,
            let name = self.nameTextField.text else {
                return nil
        }
        
        if !number.isAvailableCreditCardNumber() {
            self.showError("カード番号が不正です")
            return nil
        }
        if !expire.isAvailableCreditCardExpire() {
            self.showError("有効期限が不正です")
            return nil
        }
        if !cvc.isAvailableCreditCardCvc() {
            self.showError("CVCが不正です")
            return nil
        }
        if !name.isAvailableCreditCardName() {
            self.showError("お名前が不正です")
            return nil
        }
        return CreditCardData(number: number, expire: expire, cvc: cvc, name: name)
    }
    
    private func purchase() {
        CartRequester.purchase(userId: SaveData.shared.userId) { [weak self] result in
            let completeViewController = self?.viewController(identifier: "CompleteViewController") as! CompleteViewController
            self?.stack(viewController: completeViewController, animationType: .horizontal)
        }
    }
    
    private func showError(_ text: String) {
        
        let action = AlertAction(title: "OK")
        self.showAlert(title: "エラー", message: text, actions: [action])
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}
