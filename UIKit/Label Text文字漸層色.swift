/* 設定Label 文字漸層色
有兩三種做法，這個作法是我最喜歡的，不需要考慮到 view 的生命週期。

原理: 在label 繪製text之前。建立一個漸層色image，再將它轉成顏色給textColor
*/




extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class GradientLabel: UILabel {
    var gradientColors: [CGColor] = []
    override func drawText(in rect: CGRect) {
        if let image = UIImage.gradientImageWithBounds(bounds: rect, colors: gradientColors) {
            self.textColor = UIColor(patternImage: image)
        }
        super.drawText(in: rect)
    }
}


