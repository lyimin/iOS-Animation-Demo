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
    private var duration : NSTimeInterval!
    private var alpha : CGFloat!
    private var isPushAnimation : Bool!
    
    convenience init(transitionDuration : NSTimeInterval, StartingAlpha : CGFloat, isBOOL : Bool) {
        self.init()
        self.duration = transitionDuration
        self.alpha = StartingAlpha
        self.isPushAnimation = isBOOL
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView : UIView = transitionContext.containerView()!
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view
        
        
        if self.isPushAnimation==true {
            toView?.alpha = alpha
            fromView?.alpha = 1
            containerView.addSubview(toView!)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
                toView?.alpha = 1
                fromView!.alpha = 0
                }, completion: { (_) -> Void in
                    fromView!.alpha = 1.0
                    transitionContext.completeTransition(true)
            })
        } else {
            fromView?.alpha = 1
            toView?.alpha = 0
            fromView?.transform = CGAffineTransformMakeScale(1, 1)
            containerView.addSubview(toView!)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                fromView?.transform = CGAffineTransformMakeScale(3, 3)
                fromView?.alpha = 0
                toView?.alpha = 1
                }, completion: { (_) -> Void in
                    fromView?.alpha = 1
                    fromView?.transform = CGAffineTransformIdentity
                    transitionContext.completeTransition(true)
            })
        }
    }
}
