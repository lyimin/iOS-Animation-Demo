//
//  ProgressView.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/5/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    @IBOutlet weak var percentLabel: UILabel!
    /**
     *  进度条颜色
     */
    struct ColorPalette {
        static let teal = UIColor(red:0.27, green:0.80, blue:0.80, alpha:1.0)
        static let orange = UIColor(red:0.90, green:0.59, blue:0.20, alpha:1.0)
        static let pink = UIColor(red:0.98, green:0.12, blue:0.45, alpha:1.0)
    }
    
    // 进度条位子
    fileprivate let progressLayer = CAShapeLayer()
    fileprivate let gradientLayer = CAGradientLayer()
    
    // 总量
    var range: CGFloat = 128
    var curValue: CGFloat = 0 {
        didSet {
            animateStroke()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayers()
    }
    
    fileprivate func setupLayers() {
        // 设置位置
        progressLayer.position = CGPoint.zero
        // 设置线宽
        progressLayer.lineWidth = 3.0
        progressLayer.strokeEnd = 0.0
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.black.cgColor
        
        // 创建路径
        let radius = CGFloat(self.width/2) - progressLayer.lineWidth
        let startAngle = CGFloat(-M_PI / 2)
        let endAngle = CGFloat(3/2 * M_PI)
        let path = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        progressLayer.path = path.cgPath
        
        // 添加layer
        self.layer.addSublayer(progressLayer)
        
        // 初始化渐变颜色layer
        gradientLayer.frame = self.bounds
        
        // 设置渐变颜色
        gradientLayer.colors = [ColorPalette.teal.cgColor, ColorPalette.orange.cgColor, ColorPalette.pink.cgColor]
        // 设置渐变位置
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.mask = progressLayer // Use progress layer as mask for gradient layer.
        
        self.layer.addSublayer(gradientLayer)
        
    }
    
    func animateStroke() {
        let fromValue = progressLayer.strokeEnd
        let toValue = curValue / range
        
        
        // 执行动画
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        progressLayer.add(animation, forKey: "stroke")
        progressLayer.strokeEnd = toValue
    }
    
    class func createView() -> ProgressView {
        return Bundle.main.loadNibNamed("ProgressView", owner: nil, options: nil)!.first as! ProgressView
    }
}
