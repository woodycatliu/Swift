
/*
UIImage 染色
String 塞圖片
*/

import UIKit

extension UIImage {
    func tinted(color: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color

        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage
        } else {
            return self
        }
    }
}


extension NSMutableAttributedString {
    
    func insertImage(image: UIImage?, tintColor: UIColor? = nil, bounds: CGRect = .zero, at: Int) {
        let imageAttachment = NSTextAttachment()
        if let tintColor = tintColor{
            // 搭配自己的UIImageExtension
            imageAttachment.image = image?.tinted(color: tintColor)
        } else {
            imageAttachment.image = image
        }
        imageAttachment.bounds = bounds
        insert(NSAttributedString(attachment: imageAttachment), at: at)
    }
    
    func appendImage(image: UIImage?, tintColor: UIColor? = nil, bounds: CGRect = .zero) {
        let attachment = NSTextAttachment()
        if let tintColor = tintColor{
            // 搭配自己的UIImageExtension
            attachment.image = image?.tinted(color: tintColor)
        } else {
            attachment.image = image
        }
        attachment.bounds = bounds
        append(NSAttributedString(attachment: attachment))
    }
}
