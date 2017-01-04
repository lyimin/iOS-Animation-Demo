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
        btn.setTitleColor(UIColor.white, for: UIControlState())
        btn.setTitle("转场", for: UIControlState())
        btn.addTarget(self, action: #selector(JSFirstViewController.btnDidClick), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    // 点击按钮
    @objc fileprivate func btnDidClick() {
        let secondVC = JSSecondViewController()
        secondVC.modalPresentationStyle = .overCurrentContext
        secondVC.transitioningDelegate = self
        self.present(secondVC, animated: true, completion: nil)
    }
    
    // MARK: -UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return JSTransition(isDismissed: false)
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return JSTransition(isDismissed: true)
        
    }
    
}
