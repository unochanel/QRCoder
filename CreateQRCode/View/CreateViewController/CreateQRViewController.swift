//
//  CreateQRViewController.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/26.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateQRViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: CreateQRViewModel!
    
    @IBOutlet private weak var pickedQRImageButton: UIButton!
    @IBOutlet private weak var urlTextField: UITextField!
    @IBOutlet private weak var qrImageView: UIImageView!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var readerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindViewModel()
    }
    
    private func configure() {
        urlTextField.delegate = self
    }
    
    private func bindViewModel() {
        let input = CreateQRViewModel.Input(
            registerButtonDidTap: registerButton.rx.tap.asDriver(),
            readerButtonDidTap: readerButton.rx.tap.asDriver(),
            pickedQRImageButtonDidTap: pickedQRImageButton.rx.tap.asDriver(),
            urlTextFieldInput: urlTextField.rx.text.orEmpty.asDriver()
        )
        
        let output = viewModel.build(input: input)
        
        output
            .createQRCodeImage
            .withLatestFrom(output.qrCodeImage)
            .drive(onNext: { [weak self] image in
                guard let wself = self else { return }
                //TODO: Alert表示
                wself.qrImageView.image = image
            })
            .disposed(by: disposeBag)
        
        output
            .presentQRReaderViewController
            .drive(onNext: { [weak self] in
                guard let wself = self else { return }
                let viewController = ReaderViewController.make()
                wself.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output
            .presentImagePicker
            .drive(onNext: { [weak self] in
                guard let wself = self else { return }
                let picker = UIImagePickerController()
                picker.delegate = wself
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                picker.allowsEditing = true
                wself.present(picker, animated: true)
            })
            .disposed(by: disposeBag)
        
        output
            .readQRURL
            .drive(urlTextField.rx.text)
            .disposed(by: disposeBag)

        
    }
}

extension CreateQRViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateQRViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        viewModel.qrImage.onNext(pickedImage!)
        dismiss(animated: false, completion: { () in
            let vc = R.storyboard.unkoStoryboard().instantiateInitialViewController()!
            self.present(vc, animated: true)

        })
    }
}

