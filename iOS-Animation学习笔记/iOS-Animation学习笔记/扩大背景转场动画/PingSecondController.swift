//
//  PingSecondController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/14.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class PingSecondController: UIViewController, PingIconViewController {
    fileprivate var model : PingItemModel!
    fileprivate weak var centerView : PingSecondContentView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = PingSecondContentView.contentView()
        self.centerView = view
        view.frame = self.view.bounds
        view.model = self.model
        self.view.addSubview(view)
        
        view.returnBtnDidClickWithBlock { () -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func setupState(_ initial: Bool) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    convenience init(model : PingItemModel) {
        self.init()
        self.model = model;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func pingIconImageViewForTransition(_ transition: PingTransition, willAnimateTransitionWithOperation operation: UINavigationControllerOperation, isForegroundViewController isForeground: Bool) {
        setupState(operation == .push)
        
        UIView.animate(withDuration: 0.6, delay: operation == .push ? 0.2 : 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            [self]
            self.setupState(operation == .pop)
            }) { (finished) -> Void in
        }
    }

    func pingIconColorViewForTransition(_ transition: PingTransition) -> UIView! {
        return self.centerView
    }
    
    func pingIconImageViewForTransition(_ transition: PingTransition) -> UIImageView! {
        return self.centerView.iconView
    }
}
