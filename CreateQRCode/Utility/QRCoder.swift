//
//  File.swift
//  CreateQRCode
//
//  Created by 宇野凌平 on 2018/07/27.
//  Copyright © 2018年 ryouheiuno. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRCoderDelegate {
    func qrCoder(_ qrCoder: QRCoder, didDetectQRCode url: URL)
}

protocol QRCoderProtocol {
    func configure(on view: UIView)
    func startRunning()
    func stopRunning()
    func generate(from url: String) -> UIImage?
    func scanQR(from view: UIImage) -> String?
}

final class QRCoder: NSObject, QRCoderProtocol {
    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer? = nil
    private var delegate: QRCoderDelegate?
    
    //QRCoderが生成されたタイミングで、delegateの生成も行われている
    init(delegate: QRCoderDelegate?) {
        self.delegate = delegate
    }
    
    func configure(on view: UIView) {
        configureSession()
        addVideoPreviewLayer(on: view)
    }
    
    func startRunning() {
        guard !captureSession.isRunning else {
            return
        }
        captureSession.startRunning()
    }
    
    func stopRunning() {
        guard captureSession.isRunning else {
            return
        }
        captureSession.stopRunning()
    }
    
    func generate(from url: String) -> UIImage? {
        //各returnがnilの時の処理も書いておく
        guard let _  = URL(string: url) else {
            return nil
        }
        
        let parameters: [String: Any] = [
            "inputMessage": url.data(using: .utf8)!,
            //ここの文字はなんでも良さそう
            "inputCorrectionLevel": "H"
        ]
        
        let filter = CIFilter(name: "CIQRCodeGenerator", withInputParameters: parameters)
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        
        let scaleImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cgImage = CIContext().createCGImage(scaleImage, from: scaleImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }

    func scanQR(from view: UIImage) -> String? {
        let ciImage = CIImage(image: view)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        let features = detector?.features(in: ciImage!)
        for feature in features as! [CIQRCodeFeature] {
            guard feature.messageString != nil else {
                return nil
            }
            return feature.messageString
        }
        return nil
    }
}

private extension QRCoder {
    func configureSession() {
        let deviceDiscoverySession = AVCaptureDevice
            .DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: AVMediaType.video,
                position: .back
        )
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            fatalError("Failed to get the camera device")
        }
        
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    func addVideoPreviewLayer(on view: UIView) {
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
    }
}

extension QRCoder: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count != 0 else {
            return
        }
        //データがQRコードのデータかを確かめている
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            metadataObject.type == AVMetadataObject.ObjectType.qr else {
                return
        }
        //URLならば、safariViewに飛ばす処理をかく
        guard let url = URL(string: metadataObject.stringValue!) else {
            return
        }
        delegate?.qrCoder(self, didDetectQRCode: url)
    }
}
