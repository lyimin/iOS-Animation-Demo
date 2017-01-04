//
//  PingFirstContentView.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/17.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

protocol PingFirstContentViewDelegate : AnyObject {
    func twitterItemViewClick(_ color : UIView!, icon : UIImageView!)
    func facebookItemViewClick(_ color : UIView!, icon : UIImageView!)
    func youtubeItemViewClick(_ color : UIView!, icon : UIImageView!)
}

class PingFirstContentView: UIView {
    var delegate : PingFirstContentViewDelegate?
    @IBOutlet weak var twitterItemView: UIView!
    @IBOutlet weak var twitterIconView: UIImageView!
    @IBOutlet weak var facebookItemView: UIView!
    @IBOutlet weak var faceIconView: UIImageView!
    @IBOutlet weak var youtubeItemView: UIView!
    @IBOutlet weak var youtubeIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.twitterItemView.layer.cornerRadius = 40
        self.facebookItemView.layer.cornerRadius = 40
        self.youtubeItemView.layer.cornerRadius = 40
        
        self.twitterItemView.viewAddTarget(self, action: "twitterItemViewDidClick")
        self.facebookItemView.viewAddTarget(self, action: "facebookItemViewDidClick")
        self.youtubeItemView.viewAddTarget(self, action: "youtubeItemViewDidClick")
        
    }
    
    func twitterItemViewDidClick () {
        self.delegate?.twitterItemViewClick(twitterItemView, icon: twitterIconView)
    }
    
    func facebookItemViewDidClick() {
        self.delegate?.facebookItemViewClick(facebookItemView, icon: faceIconView)
    }
    
    func youtubeItemViewDidClick() {
        self.delegate?.youtubeItemViewClick(youtubeItemView, icon:  youtubeIconView)
    }

    class func contentView() -> PingFirstContentView {
        return Bundle.main.loadNibNamed("PingFirstContentView", owner: nil, options: nil)!.first as! PingFirstContentView
    }
}
