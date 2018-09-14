
import UIKit

class CompleteViewController: UIViewController {
    
    private func findParentCartViewController(with viewController: UIViewController?) -> CartViewController? {
        
        if viewController == nil {
            return nil
        }
        if let cartViewController = viewController as? CartViewController {
            return cartViewController
        }
        return self.findParentCartViewController(with: viewController?.parent)
    }
    
    @IBAction func onTapClose(_ sender: Any) {
        
        if let cartViewController = self.findParentCartViewController(with: self) {
            cartViewController.pop(animationType: .vertical)
        }
    }
}
