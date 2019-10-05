//
//  AppDelegate.swift
//  CustomTabBarController
//
//  Created by hello on 2019/10/5.
//  Copyright © 2019 Dio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let tabBarCtr = MyTabBarController()
        self.window?.rootViewController = tabBarCtr
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        return true
    }
    
}
