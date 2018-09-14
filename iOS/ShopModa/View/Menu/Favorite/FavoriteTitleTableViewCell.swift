
import UIKit

class FavoriteTitleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var favoriteTitleLabel: UILabel!
    
    func configure(title: String) {
        self.favoriteTitleLabel.text = title
    }
}
