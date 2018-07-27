//
//  UIViewController.Container+Extension.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import Swinject
import UIKit

extension CreateQRViewController {
    static func make() -> CreateQRViewController {
        return Container.shared.resolve(CreateQRViewController.self)!
    }
}

extension ReaderViewController {
    static func make() -> ReaderViewController {
        return Container.shared.resolve(ReaderViewController.self)!
    }
}


