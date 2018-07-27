//
//  UtilityAssembly.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import Swinject

final class UtilityAssembly: Assembly {
    func assemble(container: Container) {
        container.register(QRCoderProtocol.self) { (resolver, delegate: QRCoderDelegate?) in
            return QRCoder(delegate: delegate)
        }
    }
}
