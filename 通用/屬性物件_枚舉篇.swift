/*
設計 Application UI時會有相當多的部件與屬性，當與UI設計師合作時，會碰到很多狀況。
常見狀況:
- 時常需要更改屬性，比如：顏色、長寬、照片等。
- 想同顏色、照片很多頁面的部件都相同。
這時候如果有設定屬性物件時，不同頁面都是用相同物件，更改時也只需要更改該物件即可，
不需要每一個class、每一頁面更改。
*/




protocol CustomStringConvertible {
    var description: String { get }
}

enum TabIconItem {
    enum TabTitle: CustomStringConvertible {
        case tabOne, tabTwo, tabThree, tabFour, tabFive
        var description: String {
            switch self {
            case .tabOne: return "第一頁"
            case .tabTwo: return "第二頁"
            case .tabThree: return "第四頁"
            case .tabFour: return "第三頁"
            case .tabFive: return "第五頁"
            }
        }
     }
    enum UncilickedImg: CustomStringConvertible {
        case tabOne, tabTwo, tabThree, tabFour, tabFive
         var description: String {
            switch self {
            case .tabOne: return "tab1"
            case .tabTwo: return "tab2"
            case .tabThree: return "tab3"
            case .tabFour: return "tab4"
            case .tabFive: return "tab5"
            }
         }
    }
        
    enum CilickedImg: CustomStringConvertible {
        case tabOne, tabTwo, tabThree, tabFour, tabFive
        var description: String {
            switch self {
            case .tabOne: return "tab1_clicked"
            case .tabTwo: return "tab2_clicked"
            case .tabThree: return "tab3_clicked"
            case .tabFour: return "tab4_clicked"                
            case .tabFive: return "tab5_clicked"
            }
        }
    }   
}



//MARK: USE
class CustomTabController: UITabBarController {
    
     override func viewDidLoad() {
        let controllers: [UIViewController] = [vc0, vc1, vc2, vc3, vc3]
        let image: [UIImage?] = [
            UIImage(named: TabIconItem.UncilickedImg.tabOne.description),
            UIImage(named: TabIconItem.UncilickedImg.tabTwo.description),
            UIImage(named: TabIconItem.UncilickedImg.tabThree.description),
            UIImage(named: TabIconItem.UncilickedImg.tabFour.description),
            UIImage(named: TabIconItem.UncilickedImg.tabFive.description)
        ]
        let select: [UIImage?] = [
            UIImage(named: TabIconItem.CilickedImg.tabOne.description),
            UIImage(named: TabIconItem.CilickedImg.tabTwo.description),
            UIImage(named: TabIconItem.CilickedImg.tabThree.description),
            UIImage(named: TabIconItem.CilickedImg.tabFour.description),
            UIImage(named: TabIconItem.CilickedImg.tabFive.description) ]
        let titles: [String] = [
            TabIconItem.TabTitle.tabOne.description,
            TabIconItem.TabTitle.tabTwo.description,
            TabIconItem.TabTitle.tabThree.description,
            TabIconItem.TabTitle.tabFour.description,
            TabIconItem.TabTitle.tabFive.description
        ]
        let array = Array(0...4)
        array.forEach {
            controllers[$0].tabBarItem = UITabBarItem(title: titles[$0], image: image[$0], selectedImage: select[$0])
            controllers[$0].title = titles[$0]
        }
        
        viewControllers = controllers.map{
            CustomerGroupNavigationController(rootViewController: $0)
        }
     }
}