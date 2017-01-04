//
//  LoginTransitions.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 15/12/28.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit
/// 这个类主要做转场动画
class LoginTransitions: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var duration : TimeInterval!
    fileprivate var alpha : CGFloat!
    fileprivate var isPushAnimation : Bool!
    
    convenience init(transitionDuration : TimeInterval, StartingAlpha : CGFloat, isBOOL : Bool) {
        self.init()
        self.duration = transitionDuration
        self.alpha = StartingAlpha
        self.isPushAnimation = isBOOL
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView : UIView = transitionContext.containerView
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view
        
        
        if self.isPushAnimation==true {
            toView?.alpha = alpha
            fromView?.alpha = 1
            containerView.addSubview(toView!)
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { () -> Void in
                toView?.alpha = 1
                fromView!.alpha = 0
                }, completion: { (_) -> Void in
                    fromView!.alpha = 1.0
                    transitionContext.completeTransition(true)
            })
        } else {
            fromView?.alpha = 1
            toView?.alpha = 0
            fromView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            containerView.addSubview(toView!)
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                fromView?.transform = CGAffineTransform(scaleX: 3, y: 3)
                fromView?.alpha = 0
                toView?.alpha = 1
                }, completion: { (_) -> Void in
                    fromView?.alpha = 1
                    fromView?.transform = CGAffineTransform.identity
                    transitionContext.completeTransition(true)
            })
        }
    }
}
