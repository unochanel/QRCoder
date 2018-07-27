//
//  UIStoryboard+Extension.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiateViewController<ViewController: UIViewController>(of type: ViewController.Type, withName name: String = String(describing: ViewController.self)) -> ViewController {
        
        let bundle = Bundle(for: ViewController.self)
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? ViewController else {
            fatalError("Could not find the specified view controller in the storyboard.")
        }
        return viewController
    }
}
