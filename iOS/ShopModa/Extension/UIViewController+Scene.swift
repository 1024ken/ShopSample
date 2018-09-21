//
//  UIViewController+Scene.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/01.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit

enum SceneAnimationType {
    case none
    case horizontal
    case vertical
}

extension UIViewController {
    
    func viewController(identifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    func stack(viewController: UIViewController, animationType: SceneAnimationType, completion: (() -> ())? = nil) {
        
        self.view.addSubview(viewController.view)
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        
        if animationType == .none {
            viewController.view.frame = CGRect(origin: .zero, size: self.view.frame.size)
            completion?()
        } else {
            if animationType == .horizontal {
                viewController.view.frame = CGRect(origin: CGPoint(x: self.view.frame.size.width, y: 0),
                                                   size: self.view.frame.size)
            } else {
                viewController.view.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.size.height),
                                                   size: self.view.frame.size)
            }
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                viewController.view.frame = CGRect(origin: .zero, size: self?.view.frame.size ?? .zero)
                }, completion: { _ in
                    UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
                    completion?()
            })
        }
    }
    
    func pop(animationType: SceneAnimationType) {
        
        if animationType == .none {
            self.pop()
        } else {
            var frame: CGRect
            if animationType == .horizontal {
                frame = CGRect(origin: CGPoint(x: self.view.frame.size.width, y: 0), size: self.view.frame.size)
            } else {
                frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.size.height), size: self.view.frame.size)
            }
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.view.frame = frame
                }, completion: { [weak self] _ in
                    self?.pop()
                    UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
            })
        }
    }
    
    private func pop() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func topViewController() -> TopViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.first as? TopViewController
    }
}
