
import UIKit

class TextFieldRespondableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveObserver),
                                               name: .UITextFieldTextDidChange,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UITextFieldTextDidChange, object: nil)
    }
    
    @objc func didReceiveObserver(notification: Notification) {
        self.textFieldDidChange()
    }
    
    func textFieldDidChange() {}
}
