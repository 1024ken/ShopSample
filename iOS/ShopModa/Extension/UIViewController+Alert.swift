
import UIKit

struct AlertAction {
    let title: String
    let action: (() -> ())?
    
    init(title: String, action: (() -> ())? = nil) {
        self.title = title
        self.action = action
    }
}

extension UIViewController {
    
    func showAlert(title: String? = nil, message: String? = nil, actions: [AlertAction]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: .default) { _ in
                action.action?()
            }
            alertController.addAction(alertAction)
        }
        self.present(alertController, animated: true)
    }
    
    func showNetworkError() {
        self.showAlert(title: "エラー", message: "通信に失敗しました", actions: [AlertAction(title: "OK")])
    }
}
