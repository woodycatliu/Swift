/*
UIKit constraint 設定雖然簡單，但是非常繁瑣，
往往一個View 自少就要設定 4 條 constraint ，
數量一堆也很花時間。
透過 extension UIVIew 將最常用的代碼打包，
可以簡化Constraint，加快刻畫UI的時間
*/

extension UIView {

   /// 對Super View 設定 Constraint / nil 為不設定
    /// - Parameters:
    ///   - top:自己的 topAnchor constant
    ///   - leading: 自己的leadingAnchor constant
    ///   - bottom: 自己的bottomAnchor constant
    ///   - trailing: 自己的trailingAnchor constant
      final func setConstraint(top: CGFloat?, leading: CGFloat?, bottom: CGFloat?, trailing: CGFloat?) {
           self.translatesAutoresizingMaskIntoConstraints = false
           guard let sv = self.superview else { return }
           if let top = top {
               self.topAnchor.constraint(equalTo: sv.topAnchor, constant: top).isActive = true
           }
           
           if let leading = leading {
               self.leadingAnchor.constraint(equalTo: sv.leadingAnchor, constant: leading).isActive = true
           }
           
           if let bottom = bottom {
               self.bottomAnchor.constraint(equalTo: sv.bottomAnchor, constant: bottom).isActive = true
           }
           
           if let trailing = trailing {
               self.trailingAnchor.constraint(equalTo: sv.trailingAnchor, constant: trailing).isActive = true
           }
       }
       
    
    /// 對擁有相同supvuew View 的目標設定 Constraint /  nil 為不設定
    /// - Parameters:
    ///   - target: 目標
    ///   - top: 自己的 topAnchor constant
    ///   - leading: 自己的leadingAnchor constant
    ///   - bottom: 自己的bottomAnchor constant
    ///   - trailing: 自己的trailingAnchor constant
       final func setConstraint(target: UIView, top: CGFloat?, leading: CGFloat?, bottom: CGFloat?, trailing: CGFloat?){
           self.translatesAutoresizingMaskIntoConstraints = false
           target.translatesAutoresizingMaskIntoConstraints = false
           
           if let top = top {
               self.topAnchor.constraint(equalTo: target.bottomAnchor, constant: top).isActive = true
           }
           
           if let leading = leading {
               self.leadingAnchor.constraint(equalTo: target.trailingAnchor, constant: leading).isActive = true
           }
           
           if let bottom = bottom {
               self.bottomAnchor.constraint(equalTo: target.topAnchor, constant: bottom).isActive = true
           }
           
           if let trailing = trailing {
               self.trailingAnchor.constraint(equalTo: target.leadingAnchor, constant: trailing).isActive = true
           }
       }



//USE 

class YourConstroller: UIViewController {
    private lazy var viewOne = UIView()
    private lazy var textField = UITextField()


    func initView() {
        view.addSubview(viewOne)
        view.aaddSubview(textField)

        viewOne.setConstraint(top: 0, leading: 10, bottom: nil, trailing: 10)
        viewOne.setConstraint(target: textField, top: nil, leading: nil, bottom: 5, trailing: nil)
        textField.setConstraint(top: nil, leading: 0, bottom: 50, trailing: 0)
    }


}