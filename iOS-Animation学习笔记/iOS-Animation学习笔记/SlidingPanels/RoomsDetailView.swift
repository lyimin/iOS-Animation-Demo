//
//  RoomsDetailView.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/28.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class RoomsDetailView: UIView {
    
    // 图片
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    // 背景色
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.655, green: 0.737, blue: 0.835, alpha: 0.8)
        return view
    }()
    
    // 标题
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        return label
    }()
    
    /// 详情
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(17)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.numberOfLines = 0
        return label
    }()
    
    /// 背景色渐变
    var transitionProgress: CGFloat = 0 {
        didSet {
            updateViews()
        }
    }
    /// 模型
    var room: Room? {
        didSet {
            if let room = room {
                titleLabel.text = room.title
                subtitleLabel.text = room.subtitle
                imageView.image = room.image
                overlayView.backgroundColor = room.color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        overlayView.frame = bounds
        updateViews()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    
    /**
     这个方法主要是设置图片的透明度
     */
    func updateViews() {
        // 取0~1的数
        let progress = min(max(transitionProgress, 0), 1)
        let antiProgress = 1.0 - progress
        
        let titleLabelOffsetTop: CGFloat = 20.0
        let titleLabelOffsetMiddle: CGFloat = bounds.height/2 - 44
        let titleLabelOffset = transitionProgress * titleLabelOffsetMiddle + antiProgress * titleLabelOffsetTop
        
        let subtitleLabelOffsetTop: CGFloat = 64
        let subtitleLabelOffsetMiddle: CGFloat = bounds.height/2
        let subtitleLabelOffset = transitionProgress * subtitleLabelOffsetMiddle + antiProgress * subtitleLabelOffsetTop
        
        titleLabel.frame = CGRect(x: 0, y: titleLabelOffset, width: bounds.width, height: 44)
        subtitleLabel.preferredMaxLayoutWidth = bounds.width
        subtitleLabel.frame = CGRect(x: 0, y: subtitleLabelOffset, width: bounds.width, height: subtitleLabel.font.lineHeight)
        
        imageView.alpha = progress
    }
    
    /**
     添加view 设置初始值
     */
    func setup() {
        addSubview(imageView)
        addSubview(overlayView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        clipsToBounds = true
        
        titleLabel.text = "Title of Room"
        subtitleLabel.text = "Description of Room"
        imageView.image = UIImage(named: "bicycle-garage-gray")
    }

}
