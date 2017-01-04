//
//  JSTransition.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/4/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class JSTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var isDismissed : Bool = false
    fileprivate var fromVC: UIViewController!
    fileprivate var toVC: UIViewController!
    
    convenience init(isDismissed : Bool) {
        self.init()
        self.isDismissed = isDismissed
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取fromvc和tovc
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        self.fromVC = fromVC
        self.toVC = toVC
        
        toVC?.beginAppearanceTransition(true, animated: true)
        
        if self.isDismissed {
            self.dismissAnimation(transitionContext)
        } else {
            self.presentAnimation(transitionContext)
        }
        
        fromVC?.beginAppearanceTransition(false, animated: true)
    }
    
    
    /**
     销毁动画
     */
    fileprivate func dismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        let frame = transitionContext.initialFrame(for: fromVC)
        toVC.view.frame = frame
        
        var t1 = CATransform3DIdentity
        t1.m34 = 1.0 / -1000
        t1 = CATransform3DScale(t1, 0.95, 0.95, 1)
        t1 = CATransform3DRotate(t1, 15.0 * CGFloat(M_PI) / 180.0, 1, 0, 0)
        
        // 执行动画
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic, animations: {
            
            // 开始时间：1.0*0.0 持续时间：1.0*1.0
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.fromVC.view.y = frame.height
            })
            
            // 开始时间：1.0*0.35 持续时间：1.0*0.35
            UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.35, animations: {
                self.toVC.view.layer.transform = t1;
                //透明度为1.0
                self.toVC.view.alpha = 1.0;
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.toVC.view.layer.transform = CATransform3DIdentity
            })
            
        }) { (_) in
            // 提交动画
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    /**
     进场动画
     */
    fileprivate func presentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        // 获取frame
        let frame = transitionContext.initialFrame(for: fromVC)
        // 设置toviewframe
        var offScreenFrame = frame
        offScreenFrame.origin.y = offScreenFrame.size.height
        toVC.view.frame = offScreenFrame
        // 添加view
        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        
        // 计算三维变化
        var t1 = CATransform3DIdentity
        t1.m34 = 1.0 / -1000
        //x y方向各缩放比例为0.95
        t1 = CATransform3DScale(t1, 0.95, 0.95, 1)
        //x方向旋转15°
        t1 = CATransform3DRotate(t1, 15.0 * CGFloat(M_PI)/180.0, 1, 0, 0);
        
        
        var t2 = CATransform3DIdentity
        t2.m34 = 1.0 / -1000
        //沿Y方向向上移动
        t2 = CATransform3DTranslate(t2, 0, -fromVC.view.height*0.08, 0)
        //在x y方向各缩放比例为0.8
        t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
        
        // 执行动画
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic, animations: {
            // 开始时间：1.0*0.0 持续时间：1.0*0.4
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                //执行t1动画 缩放并旋转角度
                self.fromVC.view.layer.transform = t1;
                //fromView的透明度
                self.fromVC.view.alpha = 0.6;
            })
            
            //开始时间：1.0*0.1 持续时间：1.0*0.5
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.5, animations: {
                //执行t2动画 向上平移和缩放
                self.fromVC.view.layer.transform = t2;
            })
            
            //开始时间：1.0*0.0 持续时间：1.0*1.0
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.toVC.view.frame = frame
            })
            
        }) { (_) in
            // 提交动画
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        

    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            self.toVC.view.transform = CGAffineTransform.identity
        }
    }
}

