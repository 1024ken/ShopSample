
import UIKit

class PickerTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var selectedImageView: UIImageView!
    @IBOutlet private weak var dataLabel: UILabel!
    
    func configure(title: String, isSelected: Bool) {
        
        self.selectedImageView.isHidden = !isSelected
        self.dataLabel.text = title
    }
}
