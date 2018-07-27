//
//  ViewControllerAssembly.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import UIKit
import Swinject

final class ViewControllerAssembly: Assembly {
    func assemble(container: Container) {

        //Mark: - CreateQRViewController

        container.register(CreateQRViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: CreateQRViewController.self)
            viewController.viewModel = resolver.resolve(CreateQRViewModel.self, argument: Optional<QRCoderDelegate>.none)!
            return viewController
        }

        //MARK: -ReaderViewController

        container.register(ReaderViewController.self) { resolver in
            let viewController = UIStoryboard.instantiateViewController(of: ReaderViewController.self)
            viewController.viewModel = resolver.resolve(ReaderViewModel.self)!
            return viewController
        }
    }
}
