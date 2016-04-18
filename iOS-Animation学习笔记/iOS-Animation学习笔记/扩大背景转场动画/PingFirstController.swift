//
//  PingFirstController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/14.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit


class PingFirstController : UIViewController, PingFirstContentViewDelegate, UINavigationControllerDelegate, PingIconViewController {
    
    /// 数据
    let items = [
        PingItemModel(image: UIImage(named: "icon-twitter"), color: UIColor(red: 0.255, green: 0.557, blue: 0.910, alpha: 1), name: "Twitter", summary: "Twitter is an online social networking service that enables users to send and read short 140-character messages called \"tweets\"."),
        PingItemModel(image: UIImage(named: "icon-facebook"), color: UIColor(red: 0.239, green: 0.353, blue: 0.588, alpha: 1), name: "Facebook", summary: "Facebook (formerly thefacebook) is an online social networking service headquartered in Menlo Park, California. Its name comes from a colloquialism for the directory given to students at some American universities."),
        PingItemModel(image: UIImage(named: "icon-youtube"), color: UIColor(red: 0.729, green: 0.188, blue: 0.180, alpha: 1), name: "Youtube", summary: "YouTube is a video-sharing website headquartered in San Bruno, California. The service was created by three former PayPal employees in February 2005 and has been owned by Google since late 2006. The site allows users to upload, view, and share videos.")
    ]
    
    // 记录当前点中的图标和背景色
    private weak var selectIcon : UIImageView!
    private weak var selectColor : UIView!
    //MARK: - Lify cycle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
        self.navigationController?.navigationBarHidden = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let contentView : PingFirstContentView = PingFirstContentView.contentView()
        contentView.delegate = self
        contentView.frame = self.view.bounds
        self.view.addSubview(contentView)
    }
    
    //MARK: - UINavigation Delegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push {
            return PingTransition(operation: .Push)
        } else if operation == .Pop {
            return PingTransition(operation: .Pop)
        }
        return nil
    }
    //MARK: - PingIconViewController Delegate
    func pingIconColorViewForTransition(transition: PingTransition) -> UIView! {
        if let color = selectColor {
            return color
        } else {
            return nil
        }
    }
    
    func pingIconImageViewForTransition(transition: PingTransition) -> UIImageView! {
        if let icon = selectIcon {
            return icon
        } else {
            return nil
        }
    }
    
    //MARK: - Event or Action
    func twitterItemViewClick(color: UIView!, icon: UIImageView!) {
        self.selectColor = color
        self.selectIcon = icon
        self.navigationController?.pushViewController(PingSecondController(model: items.first!
            ), animated: true)
    }
    
    func facebookItemViewClick(color: UIView!, icon: UIImageView!) {
        self.selectColor = color
        self.selectIcon = icon
        self.navigationController?.pushViewController(PingSecondController(model: items[1]), animated: true)
    }
    
    func youtubeItemViewClick(color: UIView!, icon: UIImageView!) {
        self.selectColor = color
        self.selectIcon = icon
        self.navigationController?.pushViewController(PingSecondController(model: items.last!), animated: true)
    }
    
    
}