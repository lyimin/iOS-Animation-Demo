//
//  RoomsViewController.swift
//  iOS-Animation学习笔记
//
//  Created by 梁亦明 on 16/1/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let kRoomCellScaling: CGFloat = 0.6

class RoomsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,PanelTransitionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.collectionView)
        self.collectionView.reloadData()
        self.view.addSubview(closeBtn)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.navigationBarHidden = true;
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoomCell
        cell.detailView.room = rooms[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let controller = RoomsDetailController()
        controller.room = rooms[indexPath.row]
        present(controller, animated: true, completion: nil)
    }
    
    // 拖拽完毕时调用, 这个方法主要是做分页效果
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 拿到layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // 获取宽度
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex*cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
    }
    
    func closeBtnDidClick() {
        dismiss(animated: true, completion: nil)
    }
    // MARK: PanelTransitionViewController
    
    func panelTransitionDetailViewForTransition(_ transition: RoomTransition) -> RoomsDetailView! {
        if let indexPath = selectedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? RoomCell {
                return cell.detailView
            }
        }
        return nil
    }
    //MARK: - Getter or Setter 
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置cell宽高，边距
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * kRoomCellScaling)
        let cellHeight = floor(screenSize.height * kRoomCellScaling)
        
        let insetX = (self.view.bounds.width-cellWidth) / 2.0
        let insetY = (self.view.bounds.height-cellHeight) / 2.0
        // 设置layout
        var layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight-64)
        
        var collectionView : UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(RoomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        return collectionView
    }()
    // closeBtn
    fileprivate lazy var closeBtn: UIButton = {
        var closeBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        closeBtn.setImage(UIImage(named: "close-button"), for: UIControlState())
        closeBtn.backgroundColor = UIColor.black
        closeBtn.addTarget(self, action: #selector(RoomsViewController.closeBtnDidClick), for: .touchUpInside)
        return closeBtn
    }()
    var selectedIndexPath: IndexPath?
    
    //数据源
    let rooms = [
        Room(title: "Bikes and Garages", subtitle: "Calling all bike enthusiasts", image: UIImage(named: "bicycle-garage-gray"), color: UIColor(red: 0.2594, green: 0.3019, blue: 0.3367, alpha: 0.7)),
        Room(title: "Great Coffee", subtitle: "Find the best coffee around town", image: UIImage(named: "bell-bills-coffee-gray"), color: UIColor(red: 0.6833, green: 0.4143, blue: 0.1902, alpha: 0.7)),
        Room(title: "Big Ideas", subtitle: "Great minds think alike", image: UIImage(named: "light-bulb-gray"), color: UIColor(red: 1.0, green: 0.7847, blue: 0.4615, alpha: 0.7))
    ]
}

