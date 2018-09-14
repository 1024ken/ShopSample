
import UIKit

extension UIButton {
    
    func expand() {
        
        let defaultFrame = self.frame
        
        self.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: defaultFrame.origin.x - 10,
                                 y: defaultFrame.origin.y - 10,
                                 width: defaultFrame.size.width + 20,
                                 height: defaultFrame.size.height + 20)
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.frame = defaultFrame
            }) { [weak self] _ in
                self?.isUserInteractionEnabled = true
            }
        }
    }
}
