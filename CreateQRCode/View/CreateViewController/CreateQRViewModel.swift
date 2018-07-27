//
//  CreateQRViewModel.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateQRViewModel: InjectableViewModel {
    
    typealias Dependency = (
        QRCoderProtocol
    )
    
    private let qrCoder: QRCoderProtocol
    
    init(dependency: Dependency) {
        (qrCoder) = dependency
    }
    
    struct Input {
        let registerButtonDidTap: Driver<Void>
        let readerButtonDidTap: Driver<Void>
        let urlTextFieldInput: Driver<String>
    }
    
    struct Output {
        let qrCodeImage: Driver<UIImage>
        let createQRCodeImage: Driver<Void>
        let presentQRReaderViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        let qrCodeImage = input.urlTextFieldInput
            .map(qrCoder.generate)
            .flatMap(Driver.from)
        
        return Output(
            qrCodeImage: qrCodeImage,
            createQRCodeImage: input.registerButtonDidTap,
            presentQRReaderViewController: input.readerButtonDidTap
        )
    }
}
