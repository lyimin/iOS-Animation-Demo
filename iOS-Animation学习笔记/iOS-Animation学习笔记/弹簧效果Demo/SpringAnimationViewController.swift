//
//  SpringAnimationViewController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 15/12/22.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class SpringAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(label)
        label.transform =  CGAffineTransform(translationX: -SCREEN_WIDTH, y: 0)
        label.alpha = 0
        
        // 弹簧动画  usingSpringWithDamping ：弹性 范围0-1 initialSpringVelocity：弹开距离 自己试试两个参数就知道了
        UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.allowAnimatedContent, animations: { () -> Void in
            self.label.transform = CGAffineTransform.identity
            self.label.alpha = 1
            }, completion: nil)
    }
    
    fileprivate lazy var label : UILabel = {
        var label : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.backgroundColor = UIColor.red
        label.center = self.view.center
        label.text = "弹簧效果"
        return label
    }()
}
