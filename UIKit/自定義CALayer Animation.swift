/*
自定義CALayer 動畫效果。
優點: 低花費，Layer 層繪圖動畫，不會影響外部View Layout
缺點: 不知道....(比較複雜?)
概念 (CALayer): 子類CALayer，指定一CGFloat 變數Ａ，覆寫 draw(in ctx: CGContext)依照變數Ａ做繪圖。
概念 (UIView): 子類UIView，指定self.layer 為自定義Layer，利用動畫改變變數A，更新needsplay做動畫

重點必做
(CALayer): 務必覆寫 override init(layer: Any) 將變數復植給新Layer，原理Layer動畫變更底層是持續建立layer副本做處理，
不覆寫將layer轉型成自定義Layer會副本初始化會報錯。

(UIView): 覆寫class var layerClass: AnyClass 指定為自定義 Layer，不然會初始化系統預設CALayer，UIView內轉型會報錯。
*/

// ## 範例為一條會扭動的Bar 


import UIKit

class MyLayer: CALayer {

    @objc dynamic var dynamicValue: CGFloat = 0
    var tintColor: UIColor?

    override init() {
        super.init()
    }

    // layer 為舊，self 為新（副本)
    override init(layer: Any) {
        if let other = layer as? MyLayer {
            self.dynamicValue = other.dynamicValue
            self.tintColor = other.tintColor
        } else {
            fatalError()
        }
        super.init(layer: layer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 覆寫draw: ctx 對變數 dynamicValue 繪圖
    override func draw(in ctx: CGContext) {
        let width = bounds.width
        let height = bounds.height
        
        // Bezier curve 三階曲線控制點
        let controlOne_x: CGFloat
        let controlTwo_x: CGFloat
        let controlVariable: CGFloat 

        let controlOne_y = height / 4
        let controlTwo_y = height * 3 / 4

        let  variableMulti = cos(CGFloat.pi * 2 * dynamicValue)

        // 設定控制點對 width / 2 做簡諧運動
        if bounds.width <= 20 {
            ctx.setLineWidth(width / 4)
            controlOne_x = width / 2 - width / 3
            controlTwo_x = width / 2 + width / 3
            controlVariable = width / 3 * 2
        } else {
            ctx.setLineWidth(10)
            controlOne_x = width / 2 - 10 * 3
            controlTwo_x = width / 2 + 10 * 3
            controlVariable = 10 * 3 * 2
        }

        ctx.setStrokeColor(tintColor?.cgColor ?? UIColor.black.cgColor)
        ctx.move(to: CGPoint(x: bounds.width / 2, y: 0))

        ctx.addCurve(to: CGPoint(x: bounds.width / 2, y: bounds.height), control1: CGPoint(x: controlOne_x + variable * variableValue, 
        y: controlOne_y), control2: CGPoint(x: controlTwo_x - variable * variableValue, y: controlTwo_y))

        ctx.drawPath(using: .stroke)

    }

    // 指定特定屬性的值更改時重新顯示圖層 ( @objc dynamic var dynamicValue )
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(MyLayer.dynamicValue) {
            return true
        }
        return super.needsDisplay(forKey key: key)
    }
    

    # 註一： 使用方法是 use 2
    override func action(forKey event: String) -> CAAction? {
        if event == #keyPath(MyLayer.dynamicValue) {
           let animate = CABasicAnimation(keyPath: #keyPath(MyLayer.dynamicValue))
            animate.fromValue = presentation()?.dynamicValue ?? 0
            animate.byValue = 20
            animate.duration = 1
            animate.timingFunction = CAMediaTimingFunction(name: .linear)
            animate.repeatCount = MAXFLOAT
            return animate
        }
        return super.action(forKey: event)
    }

}





// MARK: MyView

class MyView: UIView {


    private var loadingLayer: MyLayer {
        return self.layer as! MyLayer
    }

    var dynamicValue: CGFloat {
        get {
            return loadingLayer.dynamicValue
        }
        set {
            loadingLayer.dynamicValue = newValue
            loadingLayer.setNeedsDisplay()
        }
    }

    var isTwist: Bool = false

    override class var layerClass: AnyClass {
        return MyLayer.self
    }

    func setLayerTintColor(color: UIColor) {
        loadingLayer.tintColor = color
        loadingLayer.needsDisplay
    }

    func twist() {
        guard !isTwist else { 
            stopTwist() 
            return }
        
        let animate = CABasicAnimation(keyPath: #keyPath(MyLayer.dynamicValue))
        animate.fromValue = 0
        animate.toValue = 1
        animate.duration = 0.5
        animate.repeatCount = MAXFLOAT
        lodingLayer.add(animate, forKey: "twist")
        isTwist = true
    }

    func stopTwist() {
        if let dynamicValue = lodingLayer.presentation()?.dynamicValue {
            lodingLayer.dynamicValue = dynamicValue
        }
        lodingLayer.removeAnimation(forKey: "twist")
        
        //lodingLayer.removeAnimation(forKey: #keyPath(MyLayer.dynamicValue))
        isTwist = false
    }


}


// Use One 
class ViewController: UIViewController {
      override func viewDidLoad() {
        super.viewDidLoad()
        setupMyView()
        setupButton()
        button.addTarget(self, action: #selector(twist(_:)), for: .touchUpInside)
      }


      @objc func twist(_ button: UIButton) {
           twistView.twist()
           if twistView.isTwist {
                button.setTitle("Stop", for: .normal)
                button.setTitle("Stop", for: .highlighted)
            }else {
                button.setTitle("Twist", for: .normal)
                button.setTitle("Twist", for: .highlighted)
            }
      }

}

// 註一: 觸發 MyLayer 內 override func action(forKey event: String) 的動畫
// Use Two
class ViewController: UIViewController {
      override func viewDidLoad() {
        super.viewDidLoad()
        setupMyView()
        setupButton()
        button.addTarget(self, action: #selector(twist(_:)), for: .touchUpInside)
      }


      @objc func twist(_ button: UIButton) {
        if twistView.isTwist {
            twistView.stopTwist()
        }else {
            let action = twistView.layer.action(forKey: #keyPath(MyLayer.dynamicValue))
            action?.run(forKey: #keyPath(MyLayer.dynamicValue), object: twistView.layer, arguments: nil)
            twistView.isTwist = true
        }
      }
}

//MyView 內 stop改寫成

 func stopTwist() {
        if let dynamicValue = lodingLayer.presentation()?.dynamicValue {
            lodingLayer.dynamicValue = dynamicValue
        }
        lodingLayer.removeAnimation(forKey: #keyPath(MyLayer.dynamicValue))
        isTwist = false
    }