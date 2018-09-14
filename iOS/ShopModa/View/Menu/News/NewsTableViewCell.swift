
import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var presenterLabel: UILabel!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ImageStorage.shared.cancelRequest(imageView: self.newsImageView)
    }
    
    func configure(data: NewsData) {
        
        ImageStorage.shared.fetch(url: data.image, imageView: self.newsImageView)
        self.presenterLabel.text = data.presenter
        self.newsTitleLabel.text = data.title
        
        if let date = data.date {
            self.timeLabel.text = String(date: date)
        } else {
            self.timeLabel.text = ""
        }
    }
}
