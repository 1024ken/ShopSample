
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var nameLabel: UILabel!
    
    func configure(name: String, isSelected: Bool) {
        self.nameLabel.text = name
        self.nameLabel.textColor = isSelected ? .black : .lightGray
    }
    
    func labelFrame() -> CGRect {
        return self.convert(self.nameLabel.frame, to: UIApplication.shared.keyWindow)
    }
}
