//
//  ProgressAnimationController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/5/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class ProgressAnimationController: UIViewController {
    struct Gallon {
        
        // MARK: - Properties
        
        let ouncesDrank = 0
        let totalOunces = 128
        
    }
    
    let gallon = Gallon()
    
    let progressView = ProgressView.createView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(addBtn)
        
        
        progressView.center = self.view.center
        self.view.addSubview(progressView)
        
        // 设置初始值
        configureProgressView()
    }
    func configureProgressView() {
        progressView.curValue = CGFloat(gallon.ouncesDrank)
        progressView.range = CGFloat(gallon.totalOunces)
    }
    
    func addBtnDidClick() {
        guard progressView.curValue < CGFloat(gallon.totalOunces) else {
            return
        }
        
        // Increment progressView curValue.
        let eightOunceCup = 8
        progressView.curValue = progressView.curValue + CGFloat(eightOunceCup)
        
        // Update label based on progressView curValue.
        let percentage = (Double(progressView.curValue) / Double(gallon.totalOunces))
        progressView.percentLabel.text = numberAsPercentage(percentage)
    }
    
    func numberAsPercentage(number: Double) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.percentSymbol = ""
        return formatter.stringFromNumber(number)!
    }
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.ContactAdd)
        btn.addTarget(self, action: #selector(ProgressAnimationController.addBtnDidClick), forControlEvents: .TouchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 54, height: 54)
        btn.center = CGPoint(x: self.view.width/2, y: self.view.height*0.8)
        return btn
    }()
}


