//
//  PingTransition.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/18.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
// 定义一个协议返回背景色和图片icon
@objc
protocol PingIconViewController {
    /**
     返回背景色
     */
    func pingIconColorViewForTransition(transition : PingTransition) -> UIView!
    /**
     返回图标
     */
    func pingIconImageViewForTransition(transition : PingTransition) -> UIImageView!
    
    optional
    func pingIconImageViewForTransition(transition: PingTransition, willAnimateTransitionWithOperation operation: UINavigationControllerOperation, isForegroundViewController isForeground: Bool)
}

// 动画时间
private let kPingTransitionDuration: NSTimeInterval = 0.6
private let kZoomingIconTransitionZoomedScale: CGFloat = 15
private let kZoomingIconTransitionBackgroundScale: CGFloat = 0.80

class PingTransition: NSObject, UIViewControllerAnimatedTransitioning {
    // navigation状态 (push , pop)
    private var operation : UINavigationControllerOperation!
    // 定义view的状态
    typealias PingViews = (coloredView: UIView, imageView: UIView)
    enum TransitionState {
        case Initial
        case Final
    }
    
    
    convenience init(operation : UINavigationControllerOperation) {
        self.init()
        self.operation = operation
    }
    
    /**
     动画时间
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kPingTransitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 获取时间
        let duration = self.transitionDuration(transitionContext)
        // 获取fromController
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        // 获取toController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        // 获取容器
        let containerView = transitionContext.containerView()
        
        var backgroundViewController = fromVC
        var foregroundViewController = toVC
        
        if operation == .Pop {
            backgroundViewController = toVC
            foregroundViewController = fromVC
        }
        
        // 获取背景图片和颜色
        let backgroundImageView = (backgroundViewController as! PingIconViewController).pingIconImageViewForTransition(self)
        let foregroundImageView = (foregroundViewController as! PingIconViewController).pingIconImageViewForTransition(self)
        
        assert(backgroundImageView != nil, "Cannot find image view in background view controller")
        assert(foregroundImageView != nil, "Cannot find image view in foreground view controller")
        
        let backgroundColorView = (backgroundViewController as! PingIconViewController).pingIconColorViewForTransition(self)
        let foregroundColorView = (foregroundViewController as! PingIconViewController).pingIconColorViewForTransition(self)
        
        assert(backgroundColorView != nil, "Cannot find colored view in background view controller")
        assert(foregroundColorView != nil, "Cannot find colored view in foreground view controller")

        
        // 添加view到容器
        containerView?.addSubview(backgroundViewController!.view)
        // 截取fromview的背景色,和图片
        let snapshotOfColoredView = backgroundColorView.snapshotViewAfterScreenUpdates(false)
        let snapshotOfImageView = UIImageView(image: backgroundImageView.image)
        snapshotOfImageView.contentMode = .ScaleAspectFit
        
        // 设置动画属性
        backgroundColorView.hidden = true
        foregroundColorView.hidden = true
        
        backgroundImageView.hidden = true
        foregroundImageView.hidden = true
        
        containerView!.backgroundColor = UIColor.whiteColor()
        containerView!.addSubview(backgroundViewController!.view)
        containerView!.addSubview(foregroundViewController!.view)
        containerView!.addSubview(snapshotOfColoredView)
        containerView!.addSubview(snapshotOfImageView)
        
        // 设置toView的背景
        let foregroundViewBackgroundColor = foregroundViewController!.view.backgroundColor
        foregroundViewController!.view.backgroundColor = UIColor.clearColor()
        
        var preTransitionState = TransitionState.Initial
        var postTransitionState = TransitionState.Final
        
        if operation == .Pop {
            preTransitionState = TransitionState.Final
            postTransitionState = TransitionState.Initial
        }
        // 设置初始状态
        configureViewsForState(preTransitionState, containerView: containerView!, backgroundViewController: backgroundViewController!, viewsInBackground: (backgroundColorView, backgroundImageView), viewsInForeground: (foregroundColorView, foregroundImageView), snapshotViews: (snapshotOfColoredView, snapshotOfImageView))
        
        
        (foregroundViewController as? PingIconViewController)?.pingIconImageViewForTransition!(self, willAnimateTransitionWithOperation: operation, isForegroundViewController: true)
        
        foregroundViewController!.view.layoutIfNeeded()
        // 动画
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { [weak self]() -> Void in
            
                self!.configureViewsForState(postTransitionState, containerView: containerView!, backgroundViewController: backgroundViewController!, viewsInBackground: (backgroundColorView, backgroundImageView), viewsInForeground: (foregroundColorView, foregroundImageView), snapshotViews: (snapshotOfColoredView, snapshotOfImageView))
            
            }) { (_) -> Void in
                
                // 动画完成后设置 初始值
                backgroundViewController!.view.transform = CGAffineTransformIdentity
                // 移除新添加的view
                snapshotOfColoredView.removeFromSuperview()
                snapshotOfImageView.removeFromSuperview()
                
                backgroundColorView.hidden = false
                foregroundColorView.hidden = false
                
                backgroundImageView.hidden = false
                foregroundImageView.hidden = false
                
                foregroundViewController!.view.backgroundColor = foregroundViewBackgroundColor

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    /**
     设置view的状态
     
     - parameter state:                    当前状态
     - parameter containerView:            容器
     - parameter backgroundViewController: 前一个控制器
     - parameter viewsInBackground:        前一个控制器的view
     - parameter viewsInForeground:        后一个控制器的view
     - parameter snapshotViews:            做动画的view
     */
    private func configureViewsForState(state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground: PingViews, viewsInForeground: PingViews, snapshotViews: PingViews) {
        
        switch state {
            case .Initial:
                backgroundViewController.view.transform = CGAffineTransformIdentity
                backgroundViewController.view.alpha = 1
                
                // 设置做动画的view的frame
                snapshotViews.coloredView.transform = CGAffineTransformIdentity
                snapshotViews.coloredView.frame = containerView.convertRect(viewsInBackground.coloredView.frame, fromView: viewsInBackground.coloredView.superview)
                snapshotViews.imageView.frame = containerView.convertRect(viewsInBackground.imageView.frame, fromView: viewsInBackground.imageView.superview)
            
            case .Final:
                // 动画完成后设置前一个控制器的view缩放为0.8 alpha为0
                backgroundViewController.view.transform = CGAffineTransformMakeScale(kZoomingIconTransitionBackgroundScale, kZoomingIconTransitionBackgroundScale)
                backgroundViewController.view.alpha = 0
                
                // 设置动画的view的frame
                snapshotViews.coloredView.transform = CGAffineTransformMakeScale(kZoomingIconTransitionZoomedScale, kZoomingIconTransitionZoomedScale)
                snapshotViews.coloredView.center = containerView.convertPoint(viewsInForeground.imageView.center, fromView: viewsInForeground.imageView.superview)
                snapshotViews.imageView.frame = containerView.convertRect(viewsInForeground.imageView.frame, fromView: viewsInForeground.imageView.superview)
        }
    }
}
