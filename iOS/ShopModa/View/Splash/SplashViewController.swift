
import UIKit

class SplashViewController: UIViewController {
    
    enum ResultKey: String {
        case item = "Item"
        case category = "Category"
        case news = "News"
    }
    
    private var results = Dictionary<ResultKey, Bool>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh()
    }
    
    private func refresh() {
        
        if self.results[.item] != true {
            ItemRequester.shared.fetch(completion: { [weak self] result in
                self?.results[.item] = result
                self?.checkResult()
            })
        }
        if self.results[.category] != true {
            CategoryRequester.shared.fetch(completion: { [weak self] result in
                self?.results[.category] = result
                self?.checkResult()
            })
        }
        if self.results[.news] != true {
            NewsRequester.shared.fetch(completion: { [weak self] result in
                self?.results[.news] = result
                self?.checkResult()
            })
        }
    }
    
    private func checkResult() {
        
        let keys: [ResultKey] = [.item, .category, .news]
        let results = keys.map { self.results[$0] }
        if results.contains(where: { $0 == nil }) {
            return
        }
        
        if results.contains(where: { $0 == false }) {
            self.showError()
        } else {
            self.stackTop()
        }
    }
    
    private func stackTop() {
        
        let topViewController = self.viewController(identifier: "TopViewController")
        self.stack(viewController: topViewController, animationType: .none)
    }
    
    private func showError() {
        
        let retryAction = AlertAction(title: "リトライ", action: { [weak self] in
            self?.refresh()
        })
        self.showAlert(title: "エラー", message: "通信に失敗しました", actions: [retryAction])
    }
}
