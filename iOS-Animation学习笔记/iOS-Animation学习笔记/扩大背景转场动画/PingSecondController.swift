//
//  PingSecondController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/14.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class PingSecondController: UIViewController, PingIconViewController {
    private var model : PingItemModel!
    private weak var centerView : PingSecondContentView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = PingSecondContentView.contentView()
        self.centerView = view
        view.frame = self.view.bounds
        view.model = self.model
        self.view.addSubview(view)
        
        view.returnBtnDidClickWithBlock { () -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    func setupState(initial: Bool) {
        if initial {
            self.centerView.returnTopConstraint.constant = -64
            self.centerView.detailBottomConstraint.constant = -200
        }
        else {
            self.centerView.returnTopConstraint.constant = 0
            self.centerView.detailBottomConstraint.constant = 80
        }
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    convenience init(model : PingItemModel) {
        self.init()
        self.model = model;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func pingIconImageViewForTransition(transition: PingTransition, willAnimateTransitionWithOperation operation: UINavigationControllerOperation, isForegroundViewController isForeground: Bool) {
        setupState(operation == .Push)
        
        UIView.animateWithDuration(0.6, delay: operation == .Push ? 0.2 : 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            [self]
            self.setupState(operation == .Pop)
            }) { (finished) -> Void in
        }
    }

    func pingIconColorViewForTransition(transition: PingTransition) -> UIView! {
        return self.centerView
    }
    
    func pingIconImageViewForTransition(transition: PingTransition) -> UIImageView! {
        return self.centerView.iconView
    }
}
