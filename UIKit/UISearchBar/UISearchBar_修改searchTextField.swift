/*
UISearchBar 功能完整，
但是想要客制部分，Apple 提供的又太少
以下是一些想要稍微客制 UISearchBar 的方法
*/



/// 抓取searchBar 原生的textField
guard let textField = searchBar.value(forKey: "searchField") as? UITextField else { return }
    
    // 更改TextField 背景顏色
    textField.backgroundColor = UIColor()
    // 取消textField 原生圓角
    textField.borderStyle = .none
    // 自訂圓角
    textField.layer.cornerRadius = 3

    // 更改SearchBar 左邊 imageView
    if let glassIconView = textField.leftView as? UIImageView {
        glassIconView.tintColor = UIColor.white         
     }