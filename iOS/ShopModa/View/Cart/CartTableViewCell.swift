
import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var makerLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    
    private var didChangeNumber: ((Bool) -> ())?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ImageStorage.shared.cancelRequest(imageView: self.itemImageView)
        self.didChangeNumber = nil
    }
    
    func configure(data: CartData, didChangeNumber: @escaping ((Bool) -> ())) {
        
        guard let itemData = ItemRequester.shared.filter(itemId: data.itemId) else {
            return
        }
        ImageStorage.shared.fetch(url: itemData.image, imageView: self.itemImageView)
        self.itemNameLabel.text = itemData.name
        self.makerLabel.text = itemData.maker
        self.infoLabel.text = data.itemInfo
        self.priceLabel.text = String(price: itemData.price)
        
        self.numberLabel.text = "\(data.number)"
        self.didChangeNumber = didChangeNumber
    }
    
    @IBAction func onTapAdd(_ sender: Any) {
        self.didChangeNumber?(true)
    }
    
    @IBAction func onTapRemove(_ sender: Any) {
        self.didChangeNumber?(false)
    }
}
