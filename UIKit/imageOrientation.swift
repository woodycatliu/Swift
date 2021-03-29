
// return UIImage.Orientation
private func imageOrientation(deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation, 
                             cameraPosition: AVCaptureDevice.Position = .front) -> UIImage.Orientation {
       
        var deviceOrientation = deviceOrientation
        
        if deviceOrientation == .faceDown || deviceOrientation == .faceUp || deviceOrientation == .unknown {
            deviceOrientation = currectDeviceOrientation()
        }
        
        switch deviceOrientation {
        
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        case .faceUp, .faceDown, .unknown:
            return .up
        @unknown default:
            return cameraPosition == .front ? .leftMirrored : .right
        }
    }


// return Firebase MLKit  VisionDetectorImageOrientation
private func imageOrientation(deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation, 
                    cameraPosition: AVCaptureDevice.Position = .front) -> VisionDetectorImageOrientation {
        var deviceOrientation = deviceOrientation
        
        if deviceOrientation == .faceDown || deviceOrientation == .faceUp || deviceOrientation == .unknown {
            deviceOrientation = currectDeviceOrientation()
        }
        
        switch deviceOrientation {
        
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceUp, .faceDown, .unknown:
            return .topLeft
        @unknown default:
            return cameraPosition == .front ? .leftTop : .rightTop
        }
    }




private func currectDeviceOrientation()-> UIDeviceOrientation {
         let status: UIInterfaceOrientation
            
            if #available(iOS 13, *) {
                status =  UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.windowScene?.interfaceOrientation ?? .unknown
            } else {
                status = UIApplication.shared.statusBarOrientation
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