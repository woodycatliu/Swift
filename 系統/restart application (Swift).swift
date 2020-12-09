
    /// 重新啟動app
    func restartApplication() {
        let controller = yourViewController()
        let nav = UINavigationController(rootViewController: controller)
        
        if #available(iOS 13, *) {
            //移除所有ViewController
            UIApplication.shared.windows.forEach {
                $0.subviews.forEach { $0.removeFromSuperview() }
            }
            //重開ViewController
            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController = nav
        }else {
            UIApplication.shared.keyWindow?.subviews.forEach{
                $0.removeFromSuperview()
            }
            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController = nav
            
        }
    }


    /// 重新啟動有動畫 (適合重登)
    func restartApplication() {
        let controller = yourViewController()
        let nav = UINavigationController(rootViewController: controller)
        
        if #available(iOS 13, *) {
            //移除所有ViewController
            UIApplication.shared.windows.forEach {
                $0.subviews.forEach { $0.removeFromSuperview() }
            }
            //重開ViewController
            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController = nav
        }else {
            UIApplication.shared.keyWindow?.subviews.forEach{
                $0.removeFromSuperview()
            }
            guard let window = (UIApplication.shared.windows.filter{$0.isKeyWindow}).first else { return }
             window.rootViewController = nav
            // option: 選擇動畫類型
             UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)

        }
    }