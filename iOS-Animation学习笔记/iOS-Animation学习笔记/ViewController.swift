//
//  ViewController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 15/12/22.
//  Copyright © 2015年 xiaoming. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var titleArray : Array<String> = ["雪花粒子Demo","弹簧效果Demo","Twitter启动Demo","登陆动画Demo","引导页卡片Demo","扩大背景转场","SlidingPanels", "简书转场动画","进度条动画","音符加载动画"]
    var nameArray : Array<String> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cellId")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cellId")
        }
        cell?.textLabel?.text = titleArray[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var nextController : UIViewController!
        switch indexPath.row {
            
            case 0 :
                // 雪花demo
                nextController = EmitterViewController()
            case 1:
                // 弹簧Demo
                nextController = SpringAnimationViewController()
            case 2:
                // Twitter启动Demo
                nextController = SplashAnimiationController()
            case 3:
                // 登陆动画Demo
                nextController = LoginViewController()
            case 4:
                // 引导页卡片Demo
                nextController = TipFirstViewController()
            case 5:
                // 扩大背景转场
                nextController = PingFirstController()
            case 6:
                // SlidingPanels
                nextController = RoomsViewController()
                nextController.view.backgroundColor = UIColor.orangeColor()
                nextController.title = titleArray[indexPath.row]
                self.presentViewController(nextController, animated: true, completion: nil)
            return
            case 7:
                // 简书转场动画
                nextController = JSFirstViewController()
            case 8:
                // 进度条动画
                nextController = ProgressAnimationController()
            case 9:
                // 音符加载
                nextController = MusicIndicatorViewController()
        default:
        break;
        }
        nextController.view.backgroundColor = UIColor.orangeColor()
        nextController.title = titleArray[indexPath.row]
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
}

