//
//  QRCodeScaner.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/26.
//

import Foundation
import AVFoundation
import MLKit
import Combine
import UIKit

typealias SMSBocode = BarcodeSMS
typealias MLBarcode = Barcode
typealias CaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer

protocol BarcodeDetecterProtocol: AnyObject {
    func checkBarcodeFrame(_ frames: [CGRect], inSampleBufferSize size: CGSize, validScanObjectFrame: CGRect?)-> Bool
    func detectBarcodes(_ barcodes: [MLBarcode])-> Result<[Any], Error>
}

extension BarcodeDetecterProtocol {
    
    /// 將qrcode 元數據的frame 轉乘 iphone UIKit 在 videoPreviewLayer 座標
    func convertedRectOfBarcodeFrame(frame: CGRect, inSampleBufferSize size: CGSize, previewLayer: AVCaptureVideoPreviewLayer)-> CGRect {
        /// 將 掃到的QRCode.frame 轉為 imgSize 的比例
        let normalizedRect = CGRect(x: frame.origin.x / size.width, y: frame.origin.y / size.height, width: frame.size.width / size.width, height: frame.size.height / size.height)
        /// 將比例轉成 UIkit 座標
        return previewLayer.layerRectConverted(fromMetadataOutputRect: normalizedRect)
    }
}

protocol QRCodeScannerDelegate: AnyObject {
    func successToFilterContent(results: [Any])
    func scanerFailedQRCode(error: Error)
}

class QRCodeScanner: NSObject {
    
    weak var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let barcodeDetecter: BarcodeDetecterProtocol
    
    private(set) var barcodeResult = PassthroughSubject<[Any], Never>()
    
    weak var delegate: QRCodeScannerDelegate?
    
    var validScanObjectFrame: CGRect?
    
    private var scanOutsideCurrectCGRect: CGRect {
        return validScanObjectFrame ?? videoPreviewLayer?.bounds ?? UIScreen.main.bounds
    }
    
    var isCameraReady = false
    
    /// 是否顯示偵測到的Barcode 外框
    var isShowBarcodeIndicator: Bool = true
    
    /// 偵測到的Barcode 外框顏色
    var barcodeIndicatorColor: UIColor = .init(red: 51/255, green: 234/255, blue: 14/255, alpha: 1)
    
    var scanTimeBetween = 1.0
    
    var startScan: Bool = true
    
    var lastScanTime: TimeInterval = 0
    
    lazy var captureSession: AVCaptureSession = {
        let cs = AVCaptureSession()
        return cs
    }()
    
    let captureVideoDataOutput = AVCaptureVideoDataOutput()
    
    var captureVideoDataInput: AVCaptureDeviceInput?
    
    lazy var barcodeScanner: BarcodeScanner = {
        let format: BarcodeFormat = .qrCode
        let barcodeOptions = BarcodeScannerOptions(formats: format)
        let barcodeScanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
        return barcodeScanner
    }()
    
    init(barcordDetecter: BarcodeDetecterProtocol) {
        self.barcodeDetecter = barcordDetecter
        super.init()
    }
    
    func setQRCodeScanner() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
            try? captureDevice.lockForConfiguration()
            captureDevice.focusMode = .continuousAutoFocus
            captureDevice.exposureMode = .autoExpose
            captureDevice.unlockForConfiguration()
        }
        
        if captureDevice.isWhiteBalanceModeSupported(.autoWhiteBalance) {
            try? captureDevice.lockForConfiguration()
            captureDevice.whiteBalanceMode = .autoWhiteBalance
            captureDevice.unlockForConfiguration()
        }

        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.beginConfiguration()
        
        captureSession.canSetSessionPreset(.low)
        captureSession.addInput(input)
        captureVideoDataInput = input
        
        /// 影片檔像素，提供空值會依照設備預設
        captureVideoDataOutput.videoSettings = [ (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        captureVideoDataOutput.alwaysDiscardsLateVideoFrames = true
    
        
        captureSession.addOutput(captureVideoDataOutput)
        captureSession.commitConfiguration()

        
        captureVideoDataOutput.setSampleBufferDelegate(self, queue: .main)
        /// 限制鏡頭 Output 在 videoPreviewLayer bounds 內
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        
        isCameraReady = true
        startCamera()
    }
    
    
    func startCamera() {
        guard isCameraReady else { return }
        if !captureSession.isRunning{
            captureSession.startRunning()
        }
    }
    
    
    func stopCamera() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func timeExpire() -> Bool {
        if Date().timeIntervalSince1970 - lastScanTime < scanTimeBetween {
            return false
        }
        lastScanTime = Date().timeIntervalSince1970
        return true
    }
    
}


// MARK: qrcode scan change Firebase ML
extension QRCodeScanner: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        /// 鏡頭掃描控制閥
        guard startScan else { return }
        startScan = false
        
        /// Firebase ML kit meata
        let image = VisionImage(buffer: sampleBuffer)
        image.orientation = imageOrientation()
        
        /// 取出數據分析結果
        barcodeScanner.process(image) { [weak self]
            barcodes, error in
            guard let self = self else { return }
            /// 如果分析有錯誤，或是 barcodes 不存在，開啟掃瞄器
            guard error == nil, let barcodes = barcodes, !barcodes.isEmpty else {
                self.videoPreviewLayer?.drawBarcodeIndicator(frames: [], color: self.barcodeIndicatorColor)
                self.startScan = true
                return
            }
            /// 篩選 qrcodes
            self.selectBarcodes(barcodes: barcodes, sampleBuffer: sampleBuffer)
            
        }
    }
    
    
    /// 篩選掃進的 qrcode
    /// - Parameters:
    ///   - barcodes: qrcode 元數就
    ///   - sampleBuffer: 此次畫面媜。用來解析該媜的畫面size
    private func selectBarcodes(barcodes: [Barcode], sampleBuffer: CMSampleBuffer) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let videoPreviewLayer = videoPreviewLayer
        else {
            startScan = true
            return
        }
        /// 相機讀取到的畫面完整尺寸
        let imgSize = sampleBufferSize(imageBuffer)
        
        let barcodesFrame = convertBarcodesFrame(barcodes: barcodes, inSampleBufferSize: imgSize)
        
        guard barcodeDetecter.checkBarcodeFrame(barcodesFrame, inSampleBufferSize: imgSize, validScanObjectFrame: validScanObjectFrame) else {
            startScan = true
            return
        }
        
        if isShowBarcodeIndicator {
            videoPreviewLayer.drawBarcodeIndicator(frames: barcodesFrame, color: barcodeIndicatorColor)
        }
        
        let result = barcodeDetecter.detectBarcodes(barcodes)
        
        switch result {
        case .success(let results):
            barcodeResult.send(results)
            delegate?.successToFilterContent(results: results)
        case .failure(let error):
            delegate?.scanerFailedQRCode(error: error)
            startScan = true
        }
    }
    
    /// 將 sampleBufferSize 轉換為 UIImage Size
    private func sampleBufferSize(_ imageBuffer: CVImageBuffer)-> CGSize {
        let imgWidth = CVPixelBufferGetWidth(imageBuffer)
        let imgHeight = CVPixelBufferGetHeight(imageBuffer)
        return CGSize(width: imgWidth, height: imgHeight)
    }
    
    
    /// 將 [Barcode] frame 轉出來
    func convertBarcodesFrame(barcodes: [Barcode], inSampleBufferSize size: CGSize)-> [CGRect] {
        var borcodesFrame: [CGRect] = []
        autoreleasepool {
            barcodes.forEach { barcode in
                autoreleasepool {
                    let frame = convertedRectOfBarcodeFrame(frame: barcode.frame, inSampleBufferSize: size)
                    borcodesFrame.append(frame)
                }
            }
        }
        return borcodesFrame
    }
    
    /// 將qrcode 元數據的frame 轉乘 iphone UIKit 在 videoPreviewLayer 座標
    private func convertedRectOfBarcodeFrame(frame: CGRect, inSampleBufferSize size: CGSize)-> CGRect {
        guard let videoPreviewLayer = videoPreviewLayer else {
            fatalError("videoPreviewLayer is missing")
        }
        /// 將 掃到的QRCode.frame 轉為 imgSize 的比例
        let normalizedRect = CGRect(x: frame.origin.x / size.width, y: frame.origin.y / size.height, width: frame.size.width / size.width, height: frame.size.height / size.height)
        /// 將比例轉成 UIkit 座標
        return videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: normalizedRect)
    }
    
    
    private func imageOrientation(deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation, cameraPosition: AVCaptureDevice.Position = .front) -> UIImage.Orientation {
        var deviceOrientation = deviceOrientation
        
        if deviceOrientation == .faceDown || deviceOrientation == .faceUp || deviceOrientation == .unknown {
            deviceOrientation = currectDeviceOrientation()
        }
        
        switch deviceOrientation {
            
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        case .faceUp, .faceDown, .unknown:
            return .up
        @unknown default:
            return cameraPosition == .front ? .leftMirrored : .right
        }
    }
    
    
    private func currectDeviceOrientation()-> UIDeviceOrientation {
        
        let status: UIInterfaceOrientation
        
        if #available(iOS 15, *) {
            status = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation ?? .unknown
        }
        else {
            status = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.windowScene?.interfaceOrientation ?? .unknown
        }
        
        switch status {
        case .portrait, .unknown:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        @unknown default:
            return .portrait
        }
    }
    
}

extension AVCaptureVideoPreviewLayer {
    
    func drawBarcodeIndicator(frames: [CGRect], color: UIColor = .init(red: 51/255, green: 234/255, blue: 14/255, alpha: 1)) {
        removeBarcodeIndicator()
        
        frames.forEach {
            let bezierPath = UIBezierPath(rect: $0)
            let layer = CAShapeLayer()
            layer.name = "QRCodeIndicator"
            layer.frame = bounds
            layer.path = bezierPath.cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = color.cgColor
            layer.lineDashPattern = [10, 10]
            layer.lineWidth = 2
            layer.lineCap = .round
            layer.lineDashPhase = 0
            addSublayer(layer)
        }
    }
    
    func removeBarcodeIndicator() {
        sublayers?.forEach {
            if $0.name == "QRCodeIndicator" {
                $0.removeFromSuperlayer()
            }
        }
    }
    
}




extension QRCodeScanner {
    
    @objc
    func pinchToZoom(_ sender: UIPinchGestureRecognizer) {
        guard let device = captureVideoDataInput?.device,
              sender.state == .changed
        else { return }
        
        let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
        let pinchVelocityDividerFactor: CGFloat = 10.0
        
        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            
            let desiredZoomFactor = device.videoZoomFactor + atan2(sender.velocity, pinchVelocityDividerFactor)
            device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
            
        } catch {
            print(error)
        }
    }
        
    
    
}
