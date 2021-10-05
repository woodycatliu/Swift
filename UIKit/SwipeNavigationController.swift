import UIKit 

class SwipeNavigationController: UINavigationController {
        
    // 是否正在做 push Anumation
    // 用來阻擋 popanimaiotn 手勢被觸發
    fileprivate var duringPushAnimation = false
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        fullScreenSwipeGestureRecongnizer.delegate = self
        delegate = self
        view.addGestureRecognizer(fullScreenSwipeGestureRecongnizer)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
          duringPushAnimation = true
          
          super.pushViewController(viewController, animated: animated)
      }

    
    private lazy var fullScreenSwipeGestureRecongnizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer()
        
        if let cachedInteractionController = self.value(forKey: SwipePopTransitionKey.controllerKey) as? NSObject {
            let action = SwipePopTransitionKey.selectorKey
            let selector = Selector(action)
            if cachedInteractionController.responds(to: selector) {
                gestureRecognizer.addTarget(self, action: #selector(controlGlobalPlayerShowingTiming))
                gestureRecognizer.addTarget(cachedInteractionController, action: selector)
            }
        }
        
        return gestureRecognizer
    }()
}


extension SwipeNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        
        swipeNavigationController.duringPushAnimation = false
    }
    
}

extension SwipeNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // 擋住原生前端（1cm)的滑動手勢
        if gestureRecognizer == interactivePopGestureRecognizer {
            return false
        }
        
        // 非自定義的手勢，回傳true
        guard gestureRecognizer == fullScreenSwipeGestureRecongnizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && !duringPushAnimation
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SwipeNavigationController {
    
    enum SwipePopTransitionKey {
        
        static var controllerKey: String { return "_cachedInter" + "actionController" }
        
        static var selectorKey: String { return "handleNavig" + "ationTransition:" }
        
    }
    
}