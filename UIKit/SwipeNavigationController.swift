
import UIKit

class SwipeNavigationController: UINavigationController {
    fileprivate var duringPushAnimation = false
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
          duringPushAnimation = true
          
          super.pushViewController(viewController, animated: animated)
      }

}


extension SwipeNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        
        swipeNavigationController.duringPushAnimation = false
    }
    
}

extension SwipeNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
