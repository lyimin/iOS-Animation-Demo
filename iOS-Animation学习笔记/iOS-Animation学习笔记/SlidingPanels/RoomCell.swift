//
//  RoomCell.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class RoomCell: UICollectionViewCell {
    let detailView = RoomsDetailView(frame: CGRect.zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(detailView)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenBounds = UIScreen.main.bounds
        let scale = bounds.width / screenBounds.width
        
        detailView.transitionProgress = 1
        detailView.frame = screenBounds
        detailView.transform = CGAffineTransform(scaleX: scale, y: scale)
        detailView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
}
