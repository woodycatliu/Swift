/*
上一篇取消動畫使用的是 UIView.performWithoutAnimation {} 
很好用，但是還是有遺漏的部分，如果原第三方套件把動畫包在 DispathQueue.main 中
動畫就會正常運作。

這一篇介紹的方法將會強制取所任何動畫，概念上就是直接在View底層禁止安裝動畫。
主件~
開關:  UIView.setAnimationsEnabled(Bool) 
搭配～
 CATransaction.begin()
 CATransaction.setCompletionBlock {}
 CATransaction.commit()
*/


// 範例
// 試著把 setAnimationsEnabled(false) 改成 true 看看差異
class Test: ViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let vc = ViewController()

         UIView.setAnimationsEnabled(false)
         CATransaction.begin()
         CATransaction.setCompletionBlock {
             UIView.setAnimationsEnabled(true)
         }
         present(vc , animated: true,  completion: nil)

         CATransaction.commit() 
    } 
}



class MyViewController: UIViewController {
    let aniView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        aniView.backgroundColor = .white
        aniView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        aniView.layer.cornerRadius = 50
        aniView.center = view.center
        view.addSubview(aniView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 5, delay: 0, options: .repeat){
            self.aniView.alpha = 0
        }
    }
}