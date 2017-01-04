//
//  JSSecondViewController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/4/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class JSSecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        // 点击屏幕销毁控制器
        let tap = UITapGestureRecognizer(target: self, action: #selector(JSSecondViewController.tapAction))
        self.view.addGestureRecognizer(tap)
        
        // 添加白色背景的view
        let transView = UIView(frame: CGRect(x: 0, y: view.frame.size.height-400, width: view.frame.size.width, height: 400))
        transView.backgroundColor = UIColor.white
        self.view.addSubview(transView)
    }
    
    @objc fileprivate func tapAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
