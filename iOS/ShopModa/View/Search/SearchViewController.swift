
import UIKit

class SearchViewController: TextFieldRespondableViewController {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var noDataView: UIView!
    
    fileprivate var itemDatas = [ItemData]()
    
    override func textFieldDidChange() {
        
        guard let searchText = self.searchTextField.text else {
            return
        }
        self.itemDatas = ItemRequester.shared.filter(text: searchText)
        self.tableView.reloadData()
        self.noDataView.isHidden = self.itemDatas.count > 0
    }
    
    @IBAction func didEndExitOnSearchText(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        self.pop(animationType: .horizontal)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.configure(data: self.itemDatas[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        let itemDetailViewController = self.viewController(identifier: "ItemDetailViewController") as! ItemDetailViewController
        itemDetailViewController.set(itemData: self.itemDatas[indexPath.row])
        self.stack(viewController: itemDetailViewController, animationType: .horizontal)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

