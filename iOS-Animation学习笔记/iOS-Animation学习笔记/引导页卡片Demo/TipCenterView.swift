//
//  TipCenterView.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/4.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class TipCenterView: UIView {
 /// 标题
    @IBOutlet weak var titleLabel: UILabel!
 /// 图片
    @IBOutlet weak var imageView: UIImageView!
 /// page
    @IBOutlet weak var pageVIew: UIPageControl!
 /// 详情
    @IBOutlet weak var detailLabel: UILabel!
    
    /// 设置模型数据
    var model : TipModel? {
        didSet {
            titleLabel.text = model?.title ?? "No title"
            imageView.image = UIImage(named: (model?.imageURL!)!)
            detailLabel.text = model?.detailTitle ?? "No Detail Title"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置圆角
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    // 执行动画时不改变内部空间的frame
    override func alignmentRect(forFrame frame: CGRect) -> CGRect {
        return bounds
    }
}
