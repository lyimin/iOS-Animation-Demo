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
        
        loginBtn.addTarget(self, action: #selector(LoginViewController.loginBtnClick(_:)), for: .touchUpInside)
    }
    
    func loginBtnClick(_ loginBtn : LoginButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { [weak self]() -> Void in
            self?.login(loginBtn)
        }
        
        
    }
    
    fileprivate func login(_ loginBtn : LoginButton) {
        loginBtn.loginSuccessWithBlock { [weak self]() -> Void in
            let successController : LoginSuccessController = LoginSuccessController()
            successController.transitioningDelegate = self
            self?.present(successController, animated: true, completion: nil)
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LoginTransitions(transitionDuration: 0.4, StartingAlpha: 0.5, isBOOL: true)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LoginTransitions(transitionDuration: 0.4, StartingAlpha: 0.8, isBOOL: false)
    }
    
    // MARK : getter or setter
    fileprivate lazy var imgBg : UIImageView = {
        var imgBg : UIImageView = UIImageView(frame: self.view.bounds)
        imgBg.image = UIImage(named: "Login")
        return imgBg
    }()
    
    fileprivate lazy var loginBtn : LoginButton = {
        var loginBtn : LoginButton = LoginButton(frame: CGRect(x: 20, y: self.view.height - (40 + 80), width: self.view.width - 40, height: 40))
        loginBtn.setTitle("登陆", for: UIControlState())
        loginBtn.backgroundColor = UIColor(red: 1, green: 0, blue: 128/255.0, alpha: 1)
        return loginBtn
    }()
    
}
