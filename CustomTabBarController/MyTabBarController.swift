//
//  MyTabBarController.swift
//  CustomTabBarController
//
//  Created by hello on 2019/10/5.
//  Copyright © 2019 Dio. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    var imageArray = Array<Array<UIImage>>() //做动画用的图片数组
    let imageCount = 51 //每组动画图片个数
    var currentIndex = 1 //当前处于选中状态的item的下标
    var currentImageView = UIImageView() //当前的选中的tabbar按钮对应的图片容
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /** 添加四个UINavigationController **/
        let oneVC = OneViewController()
        setUpChildViewController(childViewController: oneVC, normalImageName: "tab_home_normal", selectedImageName: "tab_home_50", title: "One")
        let twoVC = TwoViewController()
        setUpChildViewController(childViewController: twoVC, normalImageName: "tab_c2c_normal", selectedImageName: "tab_c2c_50", title: "Two")
        let threeVC = ThreeViewController()
        setUpChildViewController(childViewController: threeVC, normalImageName: "tab_team_normal", selectedImageName: "tab_team_50", title: "Three")
        let fourVC = FourViewController()
        setUpChildViewController(childViewController: fourVC, normalImageName: "tab_mine_normal", selectedImageName: "tab_mine_50", title: "Four")
        
        //添加动画素材
        handleImage()
        //设置item文字颜色,让文字和图片颜色统一
        setItemFont()
        
        //使用 UITabBarControllerDelegate
        self.delegate = self
        
        /** 添加自定义tabBar, 不会影响系统item的下标值 **/
        let tab = RootTabBar()
        tab.addDelegate = self
        self.setValue(tab, forKey: "tabBar")
        
    }
    
    //添加子视图的方法
    func setUpChildViewController(childViewController:UIViewController, normalImageName:String, selectedImageName:String, title:String) {
        let navController = MyNavgationController.init(rootViewController: childViewController)
        let imageNormal = oriRenderingImage(imageName: normalImageName)
        let imageSelected = oriRenderingImage(imageName: selectedImageName)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = imageNormal
        navController.tabBarItem.selectedImage = imageSelected
        if childViewController.isKind(of: TwoViewController.classForCoder()) {
            // 设置图片和文字之间的间距
            navController.tabBarItem.imageInsets = UIEdgeInsets.init(top: -1, left: 0, bottom: 2, right: 0)
            navController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        }
        self.addChild(navController)
    }
    //获取一张原始图的方法
    func oriRenderingImage(imageName:String) -> UIImage {
        let img:UIImage = UIImage.init(named: imageName)!
        let lastImg = img.withRenderingMode(.alwaysOriginal)
        return lastImg
    }
    
    /****************************  把动画素材放入数组 *********************************/
    func handleImage() {
        let homeImagesArr = addImage(imageName: "home")
        let c2cImagesArr = addImage(imageName: "c2c")
        let teamImagesArr = addImage(imageName: "team")
        let mineImagesArr = addImage(imageName: "mine")
        
        self.imageArray.append(homeImagesArr)
        self.imageArray.append(c2cImagesArr)
        self.imageArray.append(teamImagesArr)
        self.imageArray.append(mineImagesArr)
    }
    
    func addImage(imageName:String) -> Array<UIImage> {
        var imagesArr = Array<UIImage>()
        for index in 0..<imageCount {
            var img:UIImage?
            if index < 10 {
                img = UIImage.init(named: "tab_\(imageName)_0\(index)")
            }else{
                img = UIImage.init(named: "tab_\(imageName)_\(index)")
            }
            imagesArr.append(img!)
        }
        return imagesArr
    }
    /****************************  把动画素材放入数组 *********************************/
    
    //设置tabBar的一些属性
    func setItemFont() {
        self.selectedIndex = 1 //默认选中的item
        self.tabBar.barStyle = UIBarStyle.default //tabBar样式
        self.tabBar.isTranslucent = false //tabBar透明与否
        //        self.tabBar.barTintColor = UIColor.orange //tabBar背景颜色
        
        //字体点击前的颜色
        let normalAttr:Dictionary<NSAttributedString.Key,Any> = [NSAttributedString.Key.foregroundColor:UIColor.init(red: 169 / 255.0, green: 172 / 255.0, blue: 174 / 255.0, alpha: 1.0)]
        self.tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
        //字体点击后的颜色
        //        let selectedAttr:Dictionary<NSAttributedString.Key,Any> = [NSAttributedString.Key.foregroundColor:UIColor.init(red: 101 / 255.0, green: 216 / 255.0, blue: 255 / 255.0, alpha: 1.0)]
        //        self.tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        
        self.tabBar.tintColor = UIColor.init(red: 114 / 255.0, green: 192 / 255.0, blue: 241 / 255.0, alpha: 1.0) //点击后字体颜色
    }
}

extension MyTabBarController:UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //获取当前点南的item的下标
        let index = tabBarController.children.firstIndex(of: viewController)
        print("go here \(index!)")
        //取到选中的tabBar 上的button
        let tabBarBtn = tabBarController.tabBar.subviews[index! + 1]
        //取到button上的imageView
        let imageView:UIImageView = tabBarBtn.subviews.first as! UIImageView
        if index != self.currentIndex {//刚才点击过的item 不是上一个item
            //把上一个动画取消
            self.currentImageView.stopAnimating()
            // 把上一个图片的动画图片数组置为空
            self.currentImageView.animationImages = nil
        }else{//如果点击的还是当前item则不响应, 防止重复点击一个item动画不断重复
            //拦截item的点击事件,返回false点击事件不再向下传
            return false
        }
        
        imageView.animationImages = self.imageArray[index!]
        imageView.animationRepeatCount = 1
        imageView.animationDuration = Double(self.imageArray[index!].count) * 0.025
        
        // 开始动画
        imageView.startAnimating()
        
        // 记录当前选中的按钮的图片视图
        self.currentImageView = imageView
        // 记录当前选中的下标
        self.currentIndex = index!
        
        return true
    }
    
}

extension MyTabBarController:RootTabBarDelegate {
    
    func addClick() {
        print("add succeed")
    }
    
}
