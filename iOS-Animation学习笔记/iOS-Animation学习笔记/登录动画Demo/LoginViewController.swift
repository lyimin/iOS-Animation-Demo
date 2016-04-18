//
//  LoginViewController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 15/12/25.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController,UIViewControllerTransitioningDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(imgBg)
        self.view.addSubview(loginBtn)
        
        loginBtn.addTarget(self, action: "loginBtnClick:", forControlEvents: .TouchUpInside)
    }
    
    func loginBtnClick(loginBtn : LoginButton) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC) ), dispatch_get_main_queue()) { [weak self]() -> Void in
            self?.login(loginBtn)
        }
        
        
    }
    
    private func login(loginBtn : LoginButton) {
        loginBtn.loginSuccessWithBlock { [weak self]() -> Void in
            let successController : LoginSuccessController = LoginSuccessController()
            successController.transitioningDelegate = self
            self?.presentViewController(successController, animated: true, completion: nil)
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LoginTransitions(transitionDuration: 0.4, StartingAlpha: 0.5, isBOOL: true)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LoginTransitions(transitionDuration: 0.4, StartingAlpha: 0.8, isBOOL: false)
    }
    
    // MARK : getter or setter
    private lazy var imgBg : UIImageView = {
        var imgBg : UIImageView = UIImageView(frame: self.view.bounds)
        imgBg.image = UIImage(named: "Login")
        return imgBg
    }()
    
    private lazy var loginBtn : LoginButton = {
        var loginBtn : LoginButton = LoginButton(frame: CGRectMake(20, self.view.height - (40 + 80), self.view.width - 40, 40))
        loginBtn.setTitle("登陆", forState: .Normal)
        loginBtn.backgroundColor = UIColor(red: 1, green: 0, blue: 128/255.0, alpha: 1)
        return loginBtn
    }()
    
}