//
//  ReaderViewController.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift
import RxCocoa

class ReaderViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: ReaderViewModel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    lazy var qrCoder: QRCoder = {
        return QRCoder(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCoder.configure(on: containerView)
        bindViewModel()
        qrCoder.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrCoder.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrCoder.stopRunning()
    }
    
    private func bindViewModel() {
        let input = ReaderViewModel.Input(
            backButtonDidTap: backButton.rx.tap.asDriver())
        
        let output = viewModel.build(input: input)
        
        output
            .dismissCreateQRViewController
            .drive(onNext: { [weak self] _ in
                guard let wself = self else { return }
                wself.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension ReaderViewController: QRCoderDelegate {
    func qrCoder(_ qrCoder: QRCoder, didDetectQRCode url: URL) {
        let safariView = SFSafariViewController(url: url)
        present(safariView, animated: true)
    }
}
