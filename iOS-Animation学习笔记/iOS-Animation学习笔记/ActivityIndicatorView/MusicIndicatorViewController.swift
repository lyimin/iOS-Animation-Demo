//
//  MusicIndicatorViewController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/7/14.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class MusicIndicatorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicatorView = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        indicatorView.center = self.view.center
        self.view.addSubview(indicatorView)
        indicatorView.startAnimation()
    }
}