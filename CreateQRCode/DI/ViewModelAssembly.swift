//
//  ViewModelAssembly.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import Swinject

final class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        
        //MARK: - CreateQRViewModel
        
        container.register(CreateQRViewModel.self) { (resolver, delegate: QRCoderDelegate?) in
            return CreateQRViewModel(dependency:
                resolver.resolve(QRCoderProtocol.self, argument: delegate)!
            )
        }

        //MARK: - ReaderViewModel

        container.register(ReaderViewModel.self) { (resolver) in
            return ReaderViewModel()
        }
    }
}
