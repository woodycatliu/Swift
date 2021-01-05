/*
輕量跑馬燈特效。
特色：使用簡易（如CABasicAnimation) 使用。
自訂適應文字長度均速

property ~

fromValue: 起始位子。 
- 從頭開始設為: 0
- 從 1/4 label 寬度開始請設為: CGFloat.pi / 2 / 4
toValue: .pi / 2 完整週期

duration: 一個字符完整跑完 一個lable寬度的時間（單位：秒） 
*/


class EffectLabel: UIView {
    
    let waveLayer = CAShapeLayer()
    weak var target: AnyObject?
    
    private lazy var displayLink: CADisplayLink = {
        let link = CADisplayLink(target: target ?? self, selector: #selector(displaySelector))
        link.isPaused = true
        link.add(to: .main, forMode: .common)
        return link
    }()
    
    @objc private func displaySelector() {
        if currectValue == toValue {
            currectValue = 0
        } else if currectValue + currectByValue > toValue {
            currectValue = toValue
        } else {
            currectValue += currectByValue
        }
        layer.setNeedsDisplay()
    }
    
    
    func effectBegin() {
        displayLink.isPaused = false
    }
    
    
    // MARK: animator varibale
    private var currectValue: CGFloat = 0
    var fromValue: CGFloat = 0 {
        willSet {
            self.currectValue = newValue
        }
    }
    var toValue: CGFloat = 0
    var duration: CGFloat = 0
    
    private var valueAdaptor: CGFloat = 1
    
    var byValue: CGFloat?
    
    private var currectByValue: CGFloat {
        if self.byValue == nil {
            return (toValue - fromValue) / duration / 60 / valueAdaptor
        } else {
            return self.byValue!
        }
    }
    
    
    //MARK: label propetry
    
    var text: String?
    var textSize: CGRect = .zero
    var effectType: EffectType = .none
    var textColor: UIColor = .black
    var textFont: UIFont = .systemFont(ofSize: 20)
    var textAlignment: NSTextAlignment = .right
    
    
     override func draw(_ rect: CGRect) {
        super.draw(rect)

        adapte()
        let labelWidth: CGFloat = rect.width
        let textWidth = textSize.width
        let pathLength = labelWidth + textWidth
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        UIGraphicsPushContext(ctx)
        // right to left
//        let x = labelWidth - pathLength * cos(currectValue)
        
        // left to right
        let x = labelWidth - pathLength * sin(currectValue)

        
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: textColor, .font: textFont]
        let stringAttribute = NSAttributedString(string: self.text ?? "", attributes: attributes)
        stringAttribute.draw(at: CGPoint(x: x, y: 0))
        
        UIGraphicsPopContext()
    }
    
    
    
    /// 動態調整縮放寬度
    private func adapte() {
        if let text = text {
            textSize = NSString(string: text).boundingRect(with: .zero, options: .usesFontLeading, attributes: [.font: textFont, .foregroundColor: textColor], context: nil)
            valueAdaptor = (bounds.width + textSize.width) / bounds.width
        }
    }
  
    
    func waveEffect() {
        let originY = (self.bounds.size.height + textSize.height) / 2
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 20))
        var yPosition = 0.0
        for xPosition in 0..<Int(self.bounds.size.width) {
            yPosition = 0.5 * sin(Double(xPosition) / 180.0 * Double.pi - 4 * 5 / Double.pi) * 5 + 20
            path.addLine(to: CGPoint(x: Double(xPosition), y: yPosition))
        }
        path.addLine(to: CGPoint(x: self.bounds.size.width, y: originY))
        path.addLine(to: CGPoint(x: 0, y: originY))
        path.addLine(to: CGPoint(x: 0, y: 20))
        path.close()
        
        
        waveLayer.path = path.cgPath
    }
    
    func addWaveLayer() {
        waveLayer.fillColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.layer.insertSublayer(waveLayer, at: 0)
    }
    
    
}



/*draw(_ layer, in ctx ) 版本
override func draw(_ layer: CALayer, in ctx: CGContext) {
     adapte()
     let labelWidth: CGFloat = bounds.width
     let textWidth = textSize.width
     let pathLength = labelWidth + textWidth
        
        UIGraphicsPushContext(ctx)
        // right to left
        // let x = labelWidth - pathLength * cos(currectValue)
        
        // left to right
        let x = labelWidth - pathLength * sin(currectValue)

        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: textColor, .font: textFont]
        let stringAttribute = NSAttributedString(string: self.text ?? "", attributes: attributes)
         stringAttribute.draw(at: CGPoint(x: x, y: 0))
        
        UIGraphicsPopContext()
        }

*/