
import Foundation
import AVFoundation
import MLKit
import Combine
import UIKit


protocol BarcodeDetecterProtocol: AnyObject {
    func checkBarcodeFrame(_ barcodes: [Barcode], inSampleBufferSize: CGSize, previewLayer: AVCaptureVideoPreviewLayer)-> (permit: Bool, borcodesFrame: [CGRect])
    func detectBarcodes(_ barcodes: [Barcode])-> Result<[String], Error>
}

extension BarcodeDetecterProtocol {
    
    /// 將qrcode 元數據的frame 轉乘 iphone UIKit 在 videoPreviewLayer 座標
    private func convertedRectOfBarcodeFrame(frame: CGRect, inSampleBufferSize size: CGSize, previewLayer: AVCaptureVideoPreviewLayer)-> CGRect {
        /// 將 掃到的QRCode.frame 轉為 imgSize 的比例
        let normalizedRect = CGRect(x: frame.origin.x / size.width, y: frame.origin.y / size.height, width: frame.size.width / size.width, height: frame.size.height / size.height)
        /// 將比例轉成 UIkit 座標
        return previewLayer.layerRectConverted(fromMetadataOutputRect: normalizedRect)
    }
}



class QRCodeScanner: NSObject {
        
    weak var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let barcodeDetecter: BarcodeDetecterProtocol

    var barcodeResult = PassthroughSubject<[String], Error>()
   
    var validScanObjectFrame: CGRect?
    
    private var scanOutsideCurrectCGRect: CGRect {
        return validScanObjectFrame ?? videoPreviewLayer?.bounds ?? UIScreen.main.bounds
    }
            
    var isCameraReady = false
    
    var scanTimeBetween = 1.0
    
    var startScan: Bool = true
    
    var lastScanTime: TimeInterval = 0
    
    lazy var captureSession: AVCaptureSession = {
        let cs = AVCaptureSession()
        return cs
    }()
    
    let captureVideoDataOutput = AVCaptureVideoDataOutput()
    
    /// Firebase ML Vision
    /// 等升級 模組在更換成 Firebase ML 新版本
    /// 此版本已不推薦使用
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
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        /// 影片檔像素，提供空值會依照設備預設
        captureVideoDataOutput.videoSettings = [:]
        captureVideoDataOutput.alwaysDiscardsLateVideoFrames = true
        
        captureSession.addOutput(captureVideoDataOutput)
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
        
        let frameChecking = barcodeDetecter.checkBarcodeFrame(barcodes, inSampleBufferSize: imgSize, previewLayer: videoPreviewLayer)
        
        videoPreviewLayer.drawBarcodeIndicator(frames: frameChecking.borcodesFrame)
        
        guard frameChecking.permit else {
            startScan = true
            return
        }
                
        let result = barcodeDetecter.detectBarcodes(barcodes)
    
        switch result {
        case .success(let content):
            barcodeResult.send(content)
        case .failure(let error):
            barcodeResult.send(completion: .failure(error))
        }
        
    }
    

    
    /// 將 sampleBufferSize 轉換為 UIImage Size
    private func sampleBufferSize(_ imageBuffer: CVImageBuffer)-> CGSize {
        let imgWidth = CVPixelBufferGetWidth(imageBuffer)
        let imgHeight = CVPixelBufferGetHeight(imageBuffer)
        return CGSize(width: imgWidth, height: imgHeight)
    }
    
    /// 將qrcode 元數據的frame 轉乘 iphone UIKit 在 videoPreviewLayer 座標
    private func convertedRectOfBarcodeFrame(frame: CGRect, inSampleBufferSize size: CGSize)-> CGRect? {
        /// 將 掃到的QRCode.frame 轉為 imgSize 的比例
        let normalizedRect = CGRect(x: frame.origin.x / size.width, y: frame.origin.y / size.height, width: frame.size.width / size.width, height: frame.size.height / size.height)
        /// 將比例轉成 UIkit 座標
        return videoPreviewLayer?.layerRectConverted(fromMetadataOutputRect: normalizedRect)
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
        sublayers?.forEach {
            if $0.name == "QRCodeIndicator" {
                $0.removeFromSuperlayer()
            }
        }
        
        frames.forEach {
            let bezierPath = UIBezierPath(rect: $0)
            bezierPath.lineWidth = 1
            bezierPath.lineCapStyle = .butt
            color.setStroke()
            bezierPath.stroke()
            let layer = CAShapeLayer()
            layer.frame = bounds
            layer.path = bezierPath.cgPath
            addSublayer(layer)
        }
        
    }
    
}
