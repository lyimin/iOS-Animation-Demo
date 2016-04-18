//
//  TipSecondController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/4.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
private let kTipViewOffset: CGFloat = 500
/// 卡片高度
private let kTipViewHeight: CGFloat = 400
/// 卡片宽度
private let kTipViewWidth: CGFloat  = 300
class TipSecondController: UIViewController {
    /// 模型
    private var tipModelArray : NSArray!
    
    convenience init(tipModelArray : NSArray) {
        self.init()
        self.tipModelArray = tipModelArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupAnimator()
    }
    //MARK: - Event or Action
    
    /**
    手势处理
    */
    func panTipView(pan: UIPanGestureRecognizer) {
        let location = pan.locationInView(view)
        
        switch pan.state {
        case .Began:
            // 开始是添加一个动画手势
            animator.removeBehavior(snapBehavior)
            panBehavior = UIAttachmentBehavior(item: tipView, attachedToAnchor: location)
            animator.addBehavior(panBehavior)
            print("1.Began")
        case .Changed:
            panBehavior.anchorPoint = location
            print("2.Changed")
        case .Ended:
            print("3.end")
            fallthrough
        case .Cancelled:
            print("4.cancelled")
            let center = self.view.center
            let offset = location.x - center.x
            if fabs(offset) < 100 {
                // 如果滑动的距离小于100恢复原来状态
                animator.removeBehavior(panBehavior)
                animator.addBehavior(snapBehavior)
            }
            else {
                var nextIndex = self.index
                var position = TipViewPosition.RotatedRight
                var nextPosition = TipViewPosition.RotatedLeft
                
                if offset > 0 {
                    nextIndex -= 1
                    nextPosition = .RotatedLeft
                    position = .RotatedRight
                }
                else {
                    nextIndex += 1
                    nextPosition = .RotatedRight
                    position = .RotatedLeft
                }
                
                if nextIndex < 0 {
                    nextIndex = 0
                    nextPosition = .RotatedRight
                }
                
                let duration = 0.4
                let center = CGPoint(x: CGRectGetWidth(view.bounds)/2, y: CGRectGetHeight(view.bounds)/2)
                
                panBehavior.anchorPoint = position.viewCenter(center)
                
                dispatch_after(dispatch_time(
                    DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                        [self]
                        if nextIndex >= self.tipModelArray.count {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        else {
                            self.index = nextIndex
                            self.setupTipView(self.tipView, index: nextIndex)
                            self.resetTipView(self.tipView, position: nextPosition)
                        }
                }
            }
            
            
        default:
            ()
        }
    }
    
    
    //MARK: - Private Methods
    /**
    创建一个卡片
    */
    private func createTipView() -> TipCenterView {
        let tipView = NSBundle.mainBundle().loadNibNamed("TipCenterView", owner: nil, options: nil).first as! TipCenterView
        tipView.frame = CGRect(x: 0, y: 0, width: kTipViewWidth, height: kTipViewHeight)
        return tipView
    }
    
    /**
     重新设置卡片
     */
    func resetTipView(tipView: UIView, position: TipViewPosition) {
        animator.removeAllBehaviors()
        
        self.updateTipView(tipView, position: position)
        animator.updateItemUsingCurrentState(tipView)
        
        animator.addBehavior(attachmentBehavior)
        animator.addBehavior(snapBehavior)
    }
    
    /**
     更新卡片位置
     */
    private func updateTipView(tipView: UIView, position: TipViewPosition) {
        let center = self.view.center
        tipView.center = position.viewCenter(center)
        tipView.transform = position.viewTransform()
    }
    
    /**
     设置卡片index
     */
    private func setupTipView(tipView: TipCenterView, index: Int) {
        if index < self.tipModelArray.count {
            let tip = tipModelArray[index]
            tipView.model = tip as? TipModel
            
            tipView.pageVIew.numberOfPages = tipModelArray.count
            tipView.pageVIew.currentPage = index
        }
        else {
            tipView.model = nil
        }
    }

    /**
     执行动画
     */
    
    private func setupAnimator() {
        
        // 创建动画对象
        animator = UIDynamicAnimator(referenceView: view)
        
        var center = self.view.center
        // 创建卡片对象
        tipView = createTipView()
        view.addSubview(tipView)
        snapBehavior = UISnapBehavior(item: tipView, snapToPoint: center)
        
        center.y += kTipViewOffset
        attachmentBehavior = UIAttachmentBehavior(item: tipView, offsetFromCenter: UIOffset(horizontal: 0, vertical: kTipViewOffset), attachedToAnchor: center)
        // 设置模型
        setupTipView(tipView, index: 0)
        // 设置卡片位置执行动画
        resetTipView(tipView, position: .RotatedRight)
        
        // 添加手势
        let pan = UIPanGestureRecognizer(target: self, action: "panTipView:")
        view.addGestureRecognizer(pan)
    }
    
    //MARK: - Getter or Setter
    /// 卡片位置
    private var index : Int = 0
 /// 卡片view
    private var tipView : TipCenterView!
 /// 物理引擎动画类
    private var animator : UIDynamicAnimator!
 /// 描述一个view和一个锚相连接的情况
    private var attachmentBehavior : UIAttachmentBehavior!
 /// 将UIView通过动画吸附到某个点上
    private var snapBehavior : UISnapBehavior!
 /// 手势
    private var panBehavior: UIAttachmentBehavior!
    
    /**
     tipView的位置
     */
    enum TipViewPosition : Int {
        case Default
        case RotatedLeft
        case RotatedRight
        
        /**
         返回一个重点位置
         */
        func viewCenter(var center: CGPoint) -> CGPoint {
            switch self {
            case .RotatedLeft:
                center.y += kTipViewOffset
                center.x -= kTipViewOffset
                
            case .RotatedRight:
                center.y += kTipViewOffset
                center.x += kTipViewOffset
                
            default:
                ()
            }
            
            return center
        }
        /**
         执行旋转动画
         */
        func viewTransform() -> CGAffineTransform {
            switch self {
            case .RotatedLeft:
                return CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
                
            case .RotatedRight:
                return CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                
            default:
                return CGAffineTransformIdentity
            }
        }
        
    }
}
