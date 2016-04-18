//
//  TipViewController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/4.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class TipFirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let nextController = TipSecondController(tipModelArray: tipModelArray)
        nextController.modalPresentationStyle = .OverFullScreen
        nextController.modalTransitionStyle = .CrossDissolve
        self.presentViewController(nextController, animated: true, completion: nil)
    }
 
    /// 数据
    private lazy var tipModelArray : NSArray = {
        var model1 : TipModel = TipModel(title: "Tip #1: Don't Blink", detailTitle: "Fantastic shot of Sarah for the ALS Ice Bucket Challenge - And yes, she tried her hardest not to blink!", imageURL: "als-ice-bucket-challenge")
        var model2 : TipModel = TipModel(title: "Tip #2: Explore", detailTitle: "Get out of the house!", imageURL: "arch-architecture")
        var model3 : TipModel = TipModel(title: "Tip #3: Take in the Moment", detailTitle: "Remember that each moment is unique and will never come again.", imageURL: "man-mountains")
        
        var tipModelArray = [model1,model2,model3]
        return tipModelArray
    }()
}
