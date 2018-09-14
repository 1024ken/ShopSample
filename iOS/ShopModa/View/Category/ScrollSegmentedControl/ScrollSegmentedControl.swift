
import UIKit

class ScrollSegmentedControl: UIView {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var barLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var barWidthConstraint: NSLayoutConstraint!
    
    private var action: ((Int) -> ())?
    
    func set(titles: [String], action: @escaping ((Int) -> ())) {
        
        self.subviews.flatMap { $0 as? UIButton }.forEach {
            $0.removeFromSuperview()
        }
        self.action = action
        
        var offset = CGFloat(0)
        
        titles.enumerated().forEach { i, title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.sizeToFit()
            
            let width = button.frame.size.width + 20
            button.frame = CGRect(x: offset, y: 0, width: width, height: self.frame.size.height)
            button.tag = i
            button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
            self.scrollView.addSubview(button)
            offset += width
            
            if i == 0 {
                self.barLeadingConstraint.constant = button.frame.origin.x
                self.barWidthConstraint.constant = button.frame.size.width
                button.setTitleColor(.categorySelected, for: .normal)
            } else {
                button.setTitleColor(.categoryUnselected, for: .normal)
            }
        }
        self.scrollView.contentSize = CGSize(width: offset, height: self.frame.size.height)
    }
    
    @objc func didTap(_ button: UIButton) {
        
        self.action?(button.tag)
        
        self.didSelect(at: button.tag)
    }
    
    func didSelect(at: Int) {
        
        self.scrollView.subviews.flatMap { $0 as? UIButton }.forEach {
            $0.setTitleColor(.categoryUnselected, for: .normal)
        }
        
        if let button = (self.scrollView.subviews.filter { $0.tag == at }.flatMap { $0 as? UIButton }).first {
            self.barLeadingConstraint.constant = button.frame.origin.x
            self.barWidthConstraint.constant = button.frame.size.width
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
            
            let frame = self.scrollView.convert(button.frame, to: UIApplication.shared.keyWindow)
            if frame.origin.x + frame.size.width > self.frame.size.width {
                let x = self.scrollView.contentOffset.x + frame.origin.x + frame.size.width - self.frame.size.width
                self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
            } else if frame.origin.x < 0 {
                let x = self.scrollView.contentOffset.x + frame.origin.x
                self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
            }
            
            button.setTitleColor(.categorySelected, for: .normal)
        }
    }
}
