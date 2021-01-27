/*
有時候我們需要抓取最上層viewControoler 做些事情
比如： pushViewController or present 一個 Alert 
時常使用下面第一種方式，但是他有時候會失效，主要原因是當你事前 present另一個 ViewController時，
最上層的 VC 其實是 keyWindow.first.rootViewController 上面。
API:  eyWindow.first.rootViewController.presentedViewController

為了確保抓到最上層ViewController 可以在搭配 topViewController
*/


func getVC()-> UIViewController? {
    return UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController

}



 /// 判斷是否為最頂層 ViewController
    private func getTopViewController(vc: UIViewController)-> UIViewController {
        if let topVC = vc.presentedViewController {
            return getTopViewController(vc: topVC)
        }
        return vc
    }


   // 使用
  guard var topVC = getVC() else { return }
  topVC = getTopViewController(vc: topVC)
  topVC.present(VC, animation: true)




/// 完整版

    private func getTopViewController(vc: UIViewController? = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController)-> UIViewController? {
        
        if let navigationController = vc as? UINavigationController {
            return getTopViewController(vc: navigationController)
        } else if let tabController = vc as? UITabBarController, let selectController = tabController.selectedViewController {
            return getTopViewController(vc: selectController)
        } else if let presentedVideController = vc?.presentedViewController {
            return getTopViewController(vc: presentedVideController)
        }
        return vc
        
    }