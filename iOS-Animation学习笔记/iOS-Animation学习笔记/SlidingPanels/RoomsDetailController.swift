//
//  RoomsDetailController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/28.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class RoomsDetailController: UIViewController, PanelTransitionViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.detailView)
        view.addSubview(self.closeBtn)
        // 初始化contentView
        contentView.backgroundColor = UIColor.white
        contentView.frame = CGRect(x: 0, y: kContentViewTopOffset, width: view.bounds.width, height: view.bounds.height-kContentViewTopOffset)
        view.addSubview(contentView)
        // 添加背景图
        let imageView = UIImageView(image: UIImage(named: "IMG_0061"))
        contentView.addSubview(imageView)
        
        // 添加下拉手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(RoomsDetailController.handlePan(_:)))
        view.addGestureRecognizer(pan)
        
        detailView.room = room
        transitioningDelegate = roomTransition
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func handlePan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            fallthrough
        case .changed:
            // 改变y的值
            contentView.frame.origin.y += pan.translation(in: view).y
            pan.setTranslation(CGPoint.zero, in: view)
            
            let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
            detailView.transitionProgress = progress
            
        case .ended:
            fallthrough
        case .cancelled:
            let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
            // progress>0.5 下拉完成动画
            if progress > 0.5 {
                let duration = TimeInterval(1-progress) * kContentViewAnimationDuration
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                    [self]
                    
                    self.detailView.transitionProgress = 1
                    self.contentView.frame.origin.y = self.view.bounds.height - self.kContentViewBottomOffset
                    
                    }, completion: nil)
            }
            // progress<0.5 收回动画
            else {
                let duration = TimeInterval(progress) * kContentViewAnimationDuration
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                    [self]
                    
                    self.detailView.transitionProgress = 0
                    self.contentView.frame.origin.y = self.kContentViewTopOffset
                    
                    }, completion: nil)
            }
            
        default:
            ()
        }
    }
    
    func closeBtnDidClick() {
        dismiss(animated: true, completion: nil)
    }

    func panelTransitionDetailViewForTransition(_ transition: RoomTransition) -> RoomsDetailView! {
        return detailView
    }
    
    func panelTransitionWillAnimateTransition(_ transition: RoomTransition, presenting: Bool, isForeground: Bool) {
        if presenting {
            contentView.frame.origin.y = view.bounds.height
            closeBtn.alpha = 0
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                [self]
                self.contentView.frame.origin.y = self.kContentViewTopOffset
                self.closeBtn.alpha = 1
                }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                [self]
                self.contentView.frame.origin.y = self.view.bounds.height
                self.closeBtn.alpha = 0
                }, completion: nil)
        }
    }
    //MARK: --------------------------- Getter or Setter --------------------------
    // 距离顶部的距离
    fileprivate let kContentViewTopOffset: CGFloat = 64
    // 距离底部的距离
    fileprivate let kContentViewBottomOffset: CGFloat = 64
    // 动画时间
    fileprivate let kContentViewAnimationDuration: TimeInterval = 1.4
    let roomTransition = RoomTransition()
    // 模型
    var room: Room?
    
    // contentView
    let contentView = UIView()
    // view
    fileprivate lazy var detailView : RoomsDetailView = {
        var detailView = RoomsDetailView(frame: self.view.bounds)
        return detailView
    }()
    // closeBtn
    fileprivate lazy var closeBtn: UIButton = {
        var closeBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        closeBtn.setImage(UIImage(named: "close-button"), for: UIControlState())
        closeBtn.addTarget(self, action: #selector(RoomsDetailController.closeBtnDidClick), for: .touchUpInside)
        return closeBtn
    }()
}
