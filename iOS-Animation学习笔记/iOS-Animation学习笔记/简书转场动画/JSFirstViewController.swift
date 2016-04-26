//
//  JSFirstViewController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/4/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class JSFirstViewController: UIViewController, UIViewControllerTransitioningDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        btn.center = self.view.center
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.setTitle("转场", forState: .Normal)
        btn.addTarget(self, action: #selector(JSFirstViewController.btnDidClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)
    }
    
    // 点击按钮
    @objc private func btnDidClick() {
        let secondVC = JSSecondViewController()
        secondVC.modalPresentationStyle = .OverCurrentContext
        secondVC.transitioningDelegate = self
        self.presentViewController(secondVC, animated: true, completion: nil)
    }
    
    // MARK: -UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return JSTransition(isDismissed: false)
        
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return JSTransition(isDismissed: true)
        
    }
    
}
