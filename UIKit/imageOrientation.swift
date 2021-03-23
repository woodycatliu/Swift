 private func imageOrientation(deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation, cameraPosition: AVCaptureDevice.Position = .front) -> UIImage.Orientation {
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