//
//  RoomTransition.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/4/18.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class RoomTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    /**
     状态
     
     - None:       无
     - Presenting: 进入
     - Dismissing: 销毁
     */
    enum State {
        case none
        case presenting
        case dismissing
    }
    
    var state = State.none
    var presentingController: UIViewController!
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        var backgroundViewController = fromViewController
        var foregroundViewController = toViewController
        if (state == .dismissing) {
            backgroundViewController = toViewController
            foregroundViewController = fromViewController
        }
        // get detail view from view controllers
        let backgroundDetailViewMaybe = (backgroundViewController as? PanelTransitionViewController)?.panelTransitionDetailViewForTransition(self)
        let foregroundDetailViewMaybe = (foregroundViewController as? PanelTransitionViewController)?.panelTransitionDetailViewForTransition(self)
        
        assert(backgroundDetailViewMaybe != nil, "Cannot find detail view in background view controller")
        assert(foregroundDetailViewMaybe != nil, "Cannot find detail view in foreground view controller")
        
        let backgroundDetailView = backgroundDetailViewMaybe!
        let foregroundDetailView = foregroundDetailViewMaybe!
        
        // add views to container
        containerView.addSubview(backgroundViewController.view)
        
        let wrapperView = UIView(frame: foregroundViewController.view.frame)
        wrapperView.layer.shadowRadius = 5
        wrapperView.layer.shadowOpacity = 0.3
        wrapperView.layer.shadowOffset = CGSize.zero
        wrapperView.addSubview(foregroundViewController.view)
        foregroundViewController.view.clipsToBounds = true
        
        containerView.addSubview(wrapperView)
        
        // perform animation
        (foregroundViewController as? PanelTransitionViewController)?.panelTransitionWillAnimateTransition?(self, presenting: state == .presenting, isForeground: true)
        
        backgroundDetailView.isHidden = true
        
        let backgroundFrame = containerView.convert(backgroundDetailView.frame, from: backgroundDetailView.superview)
        let screenBounds = UIScreen.main.bounds
        let scale = backgroundFrame.width / screenBounds.width
        
        if state == .presenting {
            wrapperView.transform = CGAffineTransform(scaleX: scale, y: scale)
            foregroundDetailView.transitionProgress = 1
        }
        else {
            wrapperView.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            [self]
            if self.state == .presenting {
                wrapperView.transform = CGAffineTransform.identity
                foregroundDetailView.transitionProgress = 0
            }
            else {
                wrapperView.transform = CGAffineTransform(scaleX: scale, y: scale)
                foregroundDetailView.transitionProgress = 1
            }
            
        }) { (finished) -> Void in
            backgroundDetailView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentingController = presenting
        if presented is PanelTransitionViewController &&
            presenting is PanelTransitionViewController {
            state = .presenting
            return self
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is PanelTransitionViewController &&
            presentingController is PanelTransitionViewController {
            state = .dismissing
            return self
        }
        return nil
    }
}

@objc
protocol PanelTransitionViewController {
    func panelTransitionDetailViewForTransition(_ transition: RoomTransition) -> RoomsDetailView!
    
    @objc optional func panelTransitionWillAnimateTransition(_ transition: RoomTransition, presenting: Bool, isForeground: Bool)
}

