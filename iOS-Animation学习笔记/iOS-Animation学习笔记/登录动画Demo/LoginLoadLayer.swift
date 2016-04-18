//
//  LoginLoadView.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 15/12/25.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class LoginLoadLayer : CAShapeLayer {
    
    convenience init(frame: CGRect) {
        self.init()
        // 利用贝塞尔画一个半圆
        // 设置frame
        self.frame = CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame))
        // 圆半径
        let radius : CGFloat = frame.size.height*0.25
        let center : CGPoint = CGPoint(x: frame.size.height*0.5, y: frame.size.height*0.5)
        // 开始角度和结束角度
        let startAngle : CGFloat = CGFloat(-M_PI_2)
        let endAngle = CGFloat(M_PI_2)
        
        let bezierPath : CGPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
        self.path = bezierPath
        
        // 设置颜色线宽
        self.fillColor = nil
        self.strokeColor = UIColor.whiteColor().CGColor
        self.lineWidth = 1;
        
        self.hidden = true
    }
    
    // 开始旋转动画
    func animation () {
        self.hidden = false
        let baseAnimation : CABasicAnimation = CABasicAnimation (keyPath: "transform.rotation.z")
        // 设置值
        baseAnimation.fromValue = 0;
        baseAnimation.toValue = M_PI_2*4
        // 设置动画次数
        baseAnimation.repeatCount = HUGE
        // 设置时间
        baseAnimation.duration = 0.5
        baseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // 动画完成不要回到原始位置
        baseAnimation.removedOnCompletion = false
        baseAnimation.fillMode = kCAFillModeForwards
        
        self.addAnimation(baseAnimation, forKey: baseAnimation.keyPath)
    }
    
    // 停止动画
    func stopAnimation() {
        self.hidden = true
        self.removeAllAnimations()
    }
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
