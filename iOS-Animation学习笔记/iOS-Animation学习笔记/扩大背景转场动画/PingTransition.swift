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
    func pingIconColorViewForTransition(_ transition : PingTransition) -> UIView!
    /**
     返回图标
     */
    func pingIconImageViewForTransition(_ transition : PingTransition) -> UIImageView!
    
    @objc optional
    func pingIconImageViewForTransition(_ transition: PingTransition, willAnimateTransitionWithOperation operation: UINavigationControllerOperation, isForegroundViewController isForeground: Bool)
}

// 动画时间
private let kPingTransitionDuration: TimeInterval = 0.6
private let kZoomingIconTransitionZoomedScale: CGFloat = 15
private let kZoomingIconTransitionBackgroundScale: CGFloat = 0.80

class PingTransition: NSObject, UIViewControllerAnimatedTransitioning {
    // navigation状态 (push , pop)
    fileprivate var operation : UINavigationControllerOperation!
    // 定义view的状态
    typealias PingViews = (coloredView: UIView, imageView: UIView)
    enum TransitionState {
        case initial
        case final
    }
    
    
    convenience init(operation : UINavigationControllerOperation) {
        self.init()
        self.operation = operation
    }
    
    /**
     动画时间
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kPingTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 获取时间
        let duration = self.transitionDuration(using: transitionContext)
        // 获取fromController
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        // 获取toController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        // 获取容器
        let containerView = transitionContext.containerView
        
        var backgroundViewController = fromVC
        var foregroundViewController = toVC
        
        if operation == .pop {
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
        containerView.addSubview(backgroundViewController!.view)
        // 截取fromview的背景色,和图片
        let snapshotOfColoredView = backgroundColorView?.snapshotView(afterScreenUpdates: false)
        let snapshotOfImageView = UIImageView(image: backgroundImageView?.image)
        snapshotOfImageView.contentMode = .scaleAspectFit
        
        // 设置动画属性
        backgroundColorView?.isHidden = true
        foregroundColorView?.isHidden = true
        
        backgroundImageView?.isHidden = true
        foregroundImageView?.isHidden = true
        
        containerView.backgroundColor = UIColor.white
        containerView.addSubview(backgroundViewController!.view)
        containerView.addSubview(foregroundViewController!.view)
        containerView.addSubview(snapshotOfColoredView!)
        containerView.addSubview(snapshotOfImageView)
        
        // 设置toView的背景
        let foregroundViewBackgroundColor = foregroundViewController!.view.backgroundColor
        foregroundViewController!.view.backgroundColor = UIColor.clear
        
        var preTransitionState = TransitionState.initial
        var postTransitionState = TransitionState.final
        
        if operation == .pop {
            preTransitionState = TransitionState.final
            postTransitionState = TransitionState.initial
        }
        // 设置初始状态
        configureViewsForState(preTransitionState, containerView: containerView, backgroundViewController: backgroundViewController!, viewsInBackground: (backgroundColorView!, backgroundImageView!), viewsInForeground: (foregroundColorView!, foregroundImageView!), snapshotViews: (snapshotOfColoredView!, snapshotOfImageView))
        
        
        (foregroundViewController as? PingIconViewController)?.pingIconImageViewForTransition!(self, willAnimateTransitionWithOperation: operation, isForegroundViewController: true)
        
        foregroundViewController!.view.layoutIfNeeded()
        // 动画
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { [weak self]() -> Void in
            
                self!.configureViewsForState(postTransitionState, containerView: containerView, backgroundViewController: backgroundViewController!, viewsInBackground: (backgroundColorView!, backgroundImageView!), viewsInForeground: (foregroundColorView!, foregroundImageView!), snapshotViews: (snapshotOfColoredView!, snapshotOfImageView))
            
            }) { (_) -> Void in
                
                // 动画完成后设置 初始值
                backgroundViewController!.view.transform = CGAffineTransform.identity
                // 移除新添加的view
                snapshotOfColoredView?.removeFromSuperview()
                snapshotOfImageView.removeFromSuperview()
                
                backgroundColorView?.isHidden = false
                foregroundColorView?.isHidden = false
                
                backgroundImageView?.isHidden = false
                foregroundImageView?.isHidden = false
                
                foregroundViewController!.view.backgroundColor = foregroundViewBackgroundColor

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
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
    fileprivate func configureViewsForState(_ state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground: PingViews, viewsInForeground: PingViews, snapshotViews: PingViews) {
        
        switch state {
            case .initial:
                backgroundViewController.view.transform = CGAffineTransform.identity
                backgroundViewController.view.alpha = 1
                
                // 设置做动画的view的frame
                snapshotViews.coloredView.transform = CGAffineTransform.identity
                snapshotViews.coloredView.frame = containerView.convert(viewsInBackground.coloredView.frame, from: viewsInBackground.coloredView.superview)
                snapshotViews.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, from: viewsInBackground.imageView.superview)
            
            case .final:
                // 动画完成后设置前一个控制器的view缩放为0.8 alpha为0
                backgroundViewController.view.transform = CGAffineTransform(scaleX: kZoomingIconTransitionBackgroundScale, y: kZoomingIconTransitionBackgroundScale)
                backgroundViewController.view.alpha = 0
                
                // 设置动画的view的frame
                snapshotViews.coloredView.transform = CGAffineTransform(scaleX: kZoomingIconTransitionZoomedScale, y: kZoomingIconTransitionZoomedScale)
                snapshotViews.coloredView.center = containerView.convert(viewsInForeground.imageView.center, from: viewsInForeground.imageView.superview)
                snapshotViews.imageView.frame = containerView.convert(viewsInForeground.imageView.frame, from: viewsInForeground.imageView.superview)
        }
    }
}
