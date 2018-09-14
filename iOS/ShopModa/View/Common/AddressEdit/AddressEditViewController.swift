
import UIKit

class AddressEditViewController: UIViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var kanaTextField: UITextField!
    @IBOutlet private weak var postCodeTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Loading.start()
        
        UserInformationRequester.fetch(userId: SaveData.shared.userId) { [weak self] (result, userInformationData) in
            Loading.stop()
            
            if result, let userInformationData = userInformationData {
                self?.nameTextField.text = userInformationData.name
                self?.kanaTextField.text = userInformationData.kana
                self?.postCodeTextField.text = userInformationData.postCode
                self?.addressTextField.text = userInformationData.address
                self?.phoneNumberTextField.text = userInformationData.phoneNumber
            } else {
                self?.showError("通信に失敗しました")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = self.parent as? CartViewController {
            self.saveButton.setTitle("次へ", for: .normal)
        }
    }
    
    @IBAction func didEndEditName(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndEditKana(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndEditPostCode(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndEditAddress(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndEditPhoneNumber(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTapSave(_ sender: Any) {
        
        guard let userInformationData = self.inputData() else {
            return
        }
        
        Loading.start()
        
        UserInformationRequester.set(userId: SaveData.shared.userId, userInformationData: userInformationData) { [weak self] result in
            Loading.stop()
            
            if result {
                if let _ = self?.parent as? CartViewController {
                    let creditCardEditViewController = self?.viewController(identifier: "CreditCardEditViewController") as! CreditCardEditViewController
                    self?.stack(viewController: creditCardEditViewController, animationType: .horizontal)
                } else {
                    let action = AlertAction(title: "閉じる", action: {
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
    
    private func inputData() -> UserInformationData? {
        
        guard let name = self.nameTextField.text,
            let kana = self.kanaTextField.text,
            let postCode = self.postCodeTextField.text,
            let address = self.addressTextField.text,
            let phoneNumber = self.phoneNumberTextField.text else {
                return nil
        }
        
        if !name.isAvailableName() {
            self.showError("お名前が不正です")
            return nil
        }
        if !kana.isAvailableName() {
            self.showError("ふりがなが不正です")
            return nil
        }
        if !postCode.isAvailablePostCode() {
            self.showError("郵便番号が不正です")
            return nil
        }
        if !address.isAvailableAddress() {
            self.showError("住所が不正です")
            return nil
        }
        if !phoneNumber.isAvailablePhoneNumber() {
            self.showError("電話番号が不正です")
            return nil
        }
        return UserInformationData(name: name, kana: kana, postCode: postCode, address: address, phoneNumber: phoneNumber)
    }
    
    private func showError(_ text: String) {
        let action = AlertAction(title: "OK")
        self.showAlert(title: "エラー", message: text, actions: [action])
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}
