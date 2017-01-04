//
//  LoginSuccessController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 15/12/26.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class LoginSuccessController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imgView = UIImageView(frame: self.view.bounds)
        imgView.image = UIImage(named: "Home")
        imgView.isUserInteractionEnabled = true
        imgView.viewAddTarget(self, action: "dismissController")
        self.view.addSubview(imgView)
    }
    
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }

}
