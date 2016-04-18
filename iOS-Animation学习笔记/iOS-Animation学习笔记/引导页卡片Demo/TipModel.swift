//
//  TipModel.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/4.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class TipModel : NSObject {
    var title: String?
    var detailTitle: String?
    var imageURL: String?
    
    convenience init(title : String, detailTitle : String, imageURL : String) {
        self.init()
        self.title = title
        self.detailTitle = detailTitle
        self.imageURL = imageURL
    }
}
