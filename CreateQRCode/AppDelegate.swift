//
//  AppDelegate.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/26.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CreateQRViewController.make()
        return true
    }
}

