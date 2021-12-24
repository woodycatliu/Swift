//
//  Created by Woody Liu on 2021/12/14.
//

import UIKit


/// backgroune Color default: gray #DDDDDD
class HorizontalBarView: UIView {
    
    override var bounds: CGRect {
        didSet {
            guard oldValue != bounds else { return }
            updateBarLayerBounds()
        }
    }
        
    private lazy var leftLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.addSublayer(layer)
        return layer
    }()
    
    private lazy var rightLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.addSublayer(layer)
        return layer
    }()
    
    
    var leftValue: Double = 0 {
        didSet {
            guard oldValue != leftValue else { return }
            drawPath()
        }
    }
    
    var rightValue: Double = 0 {
        didSet {
            guard oldValue != rightValue else { return }
            drawPath()
        }
    }
    
    /// default: blue #4D67EF
    var rightColor: UIColor = UIColor.blue {
        didSet {
            guard oldValue != rightColor else { return }
            rightLayer.fillColor = rightColor.cgColor
        }
    }
    
    /// default: red #E73333
    var leftColor: UIColor = UIColor.red {
        didSet {
            guard oldValue != leftColor else { return }
            leftLayer.fillColor = leftColor.cgColor
        }
    }
    
    
    /// 是否顯示進度條動畫
    /// defaut: false
    var isShowAnimator: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGray5
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.systemGray5
    }
}

// MARK: draw path
extension HorizontalBarView {
    
    private func updateBarLayerBounds() {
        leftLayer.frame = self.bounds
        rightLayer.frame = self.bounds
        
        leftLayer.anchorPoint = .init(x: 0, y: 0.5)
        rightLayer.anchorPoint = .init(x: 1, y: 0.5)
        
        leftLayer.frame = self.bounds
        rightLayer.frame = self.bounds
    }
    
    private func drawPath() {
        removeAnimator()
        let total = leftValue + rightValue
        let leftWidth: CGFloat = total == 0 ? 0 : bounds.width * CGFloat(leftValue) / (CGFloat(total))
        let rightWidth: CGFloat = rightValue == 0 ? 0 : bounds.width - leftWidth
        let leftFrame: CGRect = .init(x: 0, y: 0, width: leftWidth, height: bounds.height)
        let rightFrame: CGRect = .init(x: leftWidth, y: 0, width: rightWidth, height: bounds.height)

        let leftPath = UIBezierPath(rect: leftFrame)
        let rightPath = UIBezierPath(rect: rightFrame)

        leftLayer.path = leftPath.cgPath
        rightLayer.path = rightPath.cgPath
        
        leftLayer.fillColor = leftColor.cgColor
        rightLayer.fillColor = rightColor.cgColor
        
        guard isShowAnimator else { return }
        animator()
    }
    
    private func animator() {
        removeAnimator()
        let animator = CABasicAnimation(keyPath: "transform")
        animator.fromValue = CATransform3DMakeScale(0, 1, 1)
        animator.toValue = CATransform3DMakeScale(1, 1, 1)
        animator.duration = 0.5
        
        rightLayer.add(animator, forKey: "BarScale")
        leftLayer.add(animator, forKey: "BarScale")
    }
    
    private func removeAnimator() {
        rightLayer.removeAnimation(forKey: "BarScale")
        leftLayer.removeAnimation(forKey: "BarScale")
    }
    
}

// MARK: Logic
extension HorizontalBarView {
    
    @discardableResult
    func showAnimator(_ isShow: Bool)-> HorizontalBarView {
        isShowAnimator = isShow
        return self
    }
    
    @discardableResult
    func setRightBarColor(_ color: UIColor)-> HorizontalBarView {
        rightColor = color
        return self
    }
    
    @discardableResult
    func setleftBarColor(_ color: UIColor)-> HorizontalBarView {
        leftColor = color
        return self
    }
    
    func setBarValue(right rightValue: Double, left leftValue: Double) {
        self.rightValue = rightValue
        self.leftValue = leftValue
    }
}
