//
//  Injectable.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

protocol Injectable {
    associatedtype Dependency
    init(dependency: Dependency)
}
