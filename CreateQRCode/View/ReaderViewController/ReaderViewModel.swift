//
//  ReaderViewModel.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ReaderViewModel {
    struct Input {
        let backButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let dismissCreateQRViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        return Output(
            dismissCreateQRViewController: input.backButtonDidTap
        )
    }
}

