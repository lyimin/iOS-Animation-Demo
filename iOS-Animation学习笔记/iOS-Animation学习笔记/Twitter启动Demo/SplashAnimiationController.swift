//
//  SplashAnimiationController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 15/12/24.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class SplashAnimiationController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 添加一个五角星覆盖层
        let layer = CALayer()
        layer.contents = UIImage(named: "logo")?.cgImage
        layer.position = self.view.center
        layer.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.view.layer.mask = layer
        
        // 设置动画
        let maskAnimation = CAKeyframeAnimation(keyPath: "bounds")
        // 时间
        maskAnimation.duration = 1.0
        // 延迟1秒执行动画
        maskAnimation.beginTime = CACurrentMediaTime()+1.0
        
        // 设置frame
        let firstRect : CGRect = (self.view.layer.mask?.bounds)!
        let secondRect : CGRect = CGRect(x: 0, y: 0, width: 50, height: 50)
        let threeRect : CGRect = CGRect(x: 0, y: 0, width: 2000, height: 2000)
        // 设置时间，值
        maskAnimation.values = [NSValue(cgRect: firstRect),NSValue(cgRect: secondRect),NSValue(cgRect: threeRect)]
        maskAnimation.keyTimes = [NSNumber(value: 0 as Float),NSNumber(value: 0.5 as Float),NSNumber(value: 1 as Float)]
        // 设置时间函数
        maskAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        maskAnimation.isRemovedOnCompletion = false
        maskAnimation.fillMode = kCAFillModeForwards
        self.view.layer.mask?.add(maskAnimation, forKey: "logoAnimation")
        
        // self.view 的动画
        UIView.animate(withDuration: 0.3, delay: 1.3, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (_) -> Void in
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.view.transform = CGAffineTransform.identity
                })
                
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
