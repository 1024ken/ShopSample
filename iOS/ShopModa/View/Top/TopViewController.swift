
import UIKit

class TopViewController: UIViewController {
    
    @IBAction func onTapMenu(_ sender: Any) {
        let menuViewController = self.viewController(identifier: "MenuViewController")
        self.stack(viewController: menuViewController, animationType: .none)
    }
    
    @IBAction func onTapCart(_ sender: Any) {
        let cartViewController = self.viewController(identifier: "CartViewController")
        self.stack(viewController: cartViewController, animationType: .vertical)
    }
    
    @IBAction func onTapNewItem(_ sender: Any) {
        let newItemViewController = self.viewController(identifier: "NewItemViewController")
        self.stack(viewController: newItemViewController, animationType: .horizontal)
    }
    
    @IBAction func onTapPopularItem(_ sender: Any) {
        let popularItemViewController = self.viewController(identifier: "PopularItemViewController")
        self.stack(viewController: popularItemViewController, animationType: .horizontal)
    }
    
    @IBAction func onTapCategory(_ sender: Any) {
        let categoryViewController = self.viewController(identifier: "CategoryViewController")
        self.stack(viewController: categoryViewController, animationType: .horizontal)
    }
    
    @IBAction func onTapSearch(_ sender: Any) {
        let searchViewController = self.viewController(identifier: "SearchViewController")
        self.stack(viewController: searchViewController, animationType: .horizontal)
    }
}
