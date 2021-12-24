
import UIKit

class AlertController: UIAlertController {

    public convenience init(title: String?, message: String?, actions: [UIAlertAction]?) {
        self.init(title: title, message: message, preferredStyle: .alert)

        if let actions = actions {
            actions.forEach {
                action in
                self.addAction(action)
            }
        }
    }
    
    convenience init(actions: [UIAlertAction]?) {
        
        self.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let actions = actions {
            actions.forEach {
                action in
                self.addAction(action)
            }
        }
    }
    
    convenience init(title: String?, message: String?, cancel: Bool = false, confirmHandler: (()->Void)?) {
        
        self.init(title: title, message: message, preferredStyle: .alert)
        
        let okAction = CustomAlertAction(title: NSLocalizedString("確定", comment: ""), handler: confirmHandler)
        
        addAction(okAction)
        
        if cancel {
            let cancelAction = CustomAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil)
            
            addAction(cancelAction)
        }
    }
    
    public convenience init(title: String?, message: String?, confirmHandler: (()->Void)?) {
        self.init(title: title, message: message, actions: [CustomAlertAction(title: "取消"), CustomAlertAction(title: "立即登入", handler: confirmHandler)])
    }
    
    // 彈出視窗
    public func show()
    {
        let vc = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController
        return show(viewController: getTopViewController(vc: vc))
    }
    
    // 彈出視窗
    public func show(withBackdropTapDismiss: Bool)
    {
        return show(viewController: UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController, withBackdropTapDismiss: false)
    }
    
    // 彈出視窗
    public func show(viewController: UIViewController?)
    {
        return show(viewController: viewController, withBackdropTapDismiss: true)
    }
    // error
    // 彈出視窗
    public func show(viewController: UIViewController?, withBackdropTapDismiss: Bool) {
        
        viewController?.present(self, animated: true){ [weak self] in
            guard let self = self else { return }
            if withBackdropTapDismiss {
                self.addDismissesOnBackdropTap()
            }
        }
    }
    //
    // 添加點擊外框消失事件
    public func addDismissesOnBackdropTap()
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapClose(_:)))
        self.view.superview?.addGestureRecognizer(tapGestureRecognizer)
    }

    // 點擊外框消失手勢
    @objc
    private func tapClose(_ gesture: UITapGestureRecognizer) {
        self.view.superview?.removeGestureRecognizer(gesture)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /// 判斷是否為最頂層 ViewController
    private func getTopViewController(vc: UIViewController?)-> UIViewController? {
        if let topVC = vc?.presentedViewController {
            return getTopViewController(vc: topVC)
        }
        return vc
    }
}

open class CustomAlertAction: UIAlertAction {

    public convenience init(title: String) {
        self.init(title: title, style: .default)
    }
    
    public convenience init(title: String, handler: (()->Void)?) {
        self.init(title: title, style: .default){ _ in
            handler?()
        }
    }
    
    public func setTextColor(_ color: UIColor) {
        self.setValue(color, forKey: "titleTextColor")
    }
}
