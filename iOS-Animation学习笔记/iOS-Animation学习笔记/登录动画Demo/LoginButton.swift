//
//  LoginButton.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 15/12/25.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    typealias loginSuccessBlock = () -> Void

    // 登录成功回调
    var block : loginSuccessBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 设置加载是的layer
        self.layer.cornerRadius = self.height*0.5
        self.layer.masksToBounds = true
        self.addTarget(self, action: "loginBtnDidClick", forControlEvents: .TouchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AnimationDelegate
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        // 当登陆放大动画执行完后回调.并设置userinterface = true
        if anim is CABasicAnimation {
            let baseAnimation = anim as! CABasicAnimation
            if baseAnimation.keyPath == "transform.scale" {
                self.userInteractionEnabled = true
                if self.block != nil {
                    self.block!()
                }
            }
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "animationStop", userInfo: nil, repeats: false)
//            self.layer.removeAllAnimations()
        }
    }
    func animationStop() {
        self.layer.removeAllAnimations();
    }
 
    // MARK: - Action or Event
    func loginBtnDidClick () {
        self.startAnimation()
    }
    // MARK: Public Methods
    func loginSuccessWithBlock(block : loginSuccessBlock?) {
        self.block = block
        // 登陆成功后执行放大动画
        let scaleAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.delegate = self
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 30
        scaleAnimation.duration = 0.3
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        scaleAnimation.fillMode = kCAFillModeForwards
        scaleAnimation.removedOnCompletion = false
        self.layer.addAnimation(scaleAnimation, forKey: scaleAnimation.keyPath)
        self.loadView.stopAnimation()
    }
    
    // MARK: Private Methods
    private func startAnimation() {
        // 把登陆按钮变成加载按钮的动画
        let widthAnimation : CABasicAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        widthAnimation.fromValue = self.width
        widthAnimation.toValue = self.height
        widthAnimation.removedOnCompletion = false
        widthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        widthAnimation.duration = 0.1
        widthAnimation.fillMode = kCAFillModeForwards
        self.layer.addAnimation(widthAnimation, forKey: widthAnimation.keyPath)
        // 执行加载动画
        loadView.animation()
        self.userInteractionEnabled = false
    }
    
    
    // 加载loadview
    private lazy var loadView: LoginLoadLayer! = {
        let loadView : LoginLoadLayer = LoginLoadLayer(frame: self.frame)
        self.layer.addSublayer(loadView)
        return loadView
    }()
}
