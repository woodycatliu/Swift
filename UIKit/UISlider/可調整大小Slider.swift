
import UIKit


/*
 可調整原生 Slider 物件UI。
 - thumSzie: 拇指圓形的尺寸
 - trackBarHeight: 滑桿的高度
 */
class AdjustElementSizeSlider: UISlider {
    /// 拇指圓形的尺寸
    var thumSzie: CGSize = .init(width: 20, height: 20)
    /// 滑桿的高度
    var trackBarHeight: CGFloat = 5
    
    override func trackRect(forBounds: CGRect) -> CGRect {
        let rect = super.trackRect(forBounds: forBounds)
        return CGRect(origin: .init(x: rect.minX, y: rect.minY), size: .init(width: rect.width, height: trackBarHeight))
        
    }
    
    override func draw(_ rect: CGRect) {
        subviews.last?.subviews.last?.subviews.first?.transform = CGAffineTransform(scaleX: thumSzie.width / 30, y: thumSzie.height / 30)
        super.draw(rect)
    }
    
}
