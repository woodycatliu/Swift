//  Created by Woody Liu on 2021/12/16.
//

import UIKit


class PieChartView: UIView {
    
    var pathLayers: [CAShapeLayer] = []
    
    private var _values: [CGFloat] = []
    {
        didSet {
            drawPath()
        }
    }
    
    /// 高亮度 index
    ///  index: values 的 索引值
    ///  PS. 索引安全檢查
    private var highlightIndex: Set<Int> = []
    
    /// 起點位子
    /// 預設：270度（.pi * 3 / 2)
    ///  - (0 / 360) 度 :  X 軸 正數 起點
    ///  - 90 度：Y軸 負數 起點
    ///  - 180 度：X軸 負數
    ///  - 270 度 : Y 軸 正數 起點
    var startOrigin: CGFloat = .pi * 3 / 2
    
    var colors: [UIColor] = []
    
    /// default: [紅, 綠, 灰]
    private let _colors: [UIColor] = [UIColor.red, UIColor.green, UIColor.gray]
    
    var values: [Double] {
       return _values.map({ Double($0) })
    }
    
    /// 順時鐘
    /// default: false
    var clockwise: Bool = false
    
    /// 高亮線寬度
    /// default: 16
    var highlightLineWidth: CGFloat = 16
    
    /// 線寬度
    /// 預設: 10
    var lineWidth: CGFloat = 10
    
    func drawPath() {
        
        removeAllpathLayers()
        
        let total = _values.reduce(0, +)
        let ratio = _values.map({ $0 / total })
        
        var startAngle = startOrigin
        let realColors = colors.isEmpty ? _colors : colors

        for i in ratio.indices {
            autoreleasepool {
                let isHighlight = highlightIndex.contains(i)
                let tuple = arcPath(startAngle: startAngle, angleRatio: ratio[i], isHighlight: isHighlight)
                startAngle = tuple.endAngle
                let shapeLayer = CAShapeLayer()
                shapeLayer.frame = self.bounds
                shapeLayer.path = tuple.cgPath
                shapeLayer.lineWidth = tuple.lineWidth
                shapeLayer.fillColor = backgroundColor?.cgColor ?? UIColor.clear.cgColor
                let count = realColors.count
                shapeLayer.strokeColor = realColors[i % count].cgColor
                self.layer.addSublayer(shapeLayer)
                pathLayers.append(shapeLayer)
            }
        }
    }
    
    private func removeAllpathLayers() {
        while !pathLayers.isEmpty {
            pathLayers.removeFirst().removeFromSuperlayer()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawPath()
    }
}

extension PieChartView {
    
    /// 清除圓餅圖
    func clean() {
        removeAllpathLayers()
    }
    
    /// 設定圓餅圖參數
    func setValues(values: [Int]) {
        setValues(values: values.map({ CGFloat($0)}))
    }
    
    /// 設定圓餅圖參數
    func setValues(values: [Double]) {
        setValues(values: values.map({ CGFloat($0)}))
    }
    
    /// 設定圓餅圖參數
    func setValues(values: [CGFloat]) {
        self._values = values
    }
    
    /// 設定高亮的區塊
    ///  index: 傳入餅圖參數的 index
    func setHighlight(indexs: Int...) {
        highlightIndex.removeAll()
        indexs.forEach({
            highlightIndex.insert($0)
        })
        drawPath()
    }
    
}

extension PieChartView {
    
    private func arcPath(startAngle: CGFloat, angleRatio: CGFloat, isHighlight: Bool)-> (cgPath: CGPath, endAngle: CGFloat, lineWidth: CGFloat) {
        // 取短邊
        let width: CGFloat = bounds.width > bounds.height ? bounds.height : bounds.width
        
        let centrer: CGPoint = .init(x: bounds.width / 2, y: bounds.height / 2)
        
        let lineWidth: CGFloat = isHighlight ? highlightLineWidth : lineWidth
        
        let diff =  width / 2 - lineWidth * 0.5

        var radius: CGFloat = diff < 0 ? lineWidth : diff
        
        radius = isHighlight ? radius : radius - (highlightLineWidth - self.lineWidth) * 0.5
        
        let angle: CGFloat = .pi * 2 * angleRatio
        
        let endAngle: CGFloat
        
        // 逆時鐘算法
        if clockwise {
            endAngle = startAngle + angle
        }
        else {
            endAngle = startAngle - angle
        }
        let path = arcPath(arcCenter: centrer, start: startAngle, end: endAngle, radius: radius, clockwise: clockwise)
        return (path, endAngle, lineWidth)
    }
    
    private func arcPath(arcCenter: CGPoint, start startAngle: CGFloat, end endAngle: CGFloat, radius: CGFloat, clockwise: Bool)-> CGPath {
        return UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise).cgPath
    }
}
