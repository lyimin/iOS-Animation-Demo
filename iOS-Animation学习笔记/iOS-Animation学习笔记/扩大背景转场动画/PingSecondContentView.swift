//
//  PingSecondContentView.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/18.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class PingSecondContentView: UIView {
    
    typealias returnBtnClickBlock = () -> Void
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var returnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailBottomConstraint: NSLayoutConstraint!
    
    var block : returnBtnClickBlock?
    var model : PingItemModel! {
        didSet {
            self.iconView.image = model.image
            self.titleLabel.text = model.name
            self.detailLabel.text = model.summary
            self.backgroundColor = model.color
        }
    }
    
    class func contentView () -> PingSecondContentView {
        return Bundle.main.loadNibNamed("PingSecondContentView", owner: nil, options: nil)!.first as! PingSecondContentView
    }
    
    /**
     点击返回
     */
    @IBAction func returnBtnDidClick(_ sender: UIButton) {
        if self.block != nil {
            self.block!()
        }
    }
    
    func returnBtnDidClickWithBlock(_ block : @escaping returnBtnClickBlock) {
        self.block = block
    }
}
