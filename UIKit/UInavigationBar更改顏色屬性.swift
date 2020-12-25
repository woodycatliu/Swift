/*
更改 navigationBar 字體顏色
方法很多種，
只特別記錄一種萬用的
*/


func setNavigationBar() {

        // 完全全黑
        if #available(iOS 13.0, *) {
            let barAppearance =  UINavigationBarAppearance()
            // 更改背景色
            barAppearance.backgroundColor = .blue
            // 更改字體顏色
            barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
            navigationController?.navigationBar.standardAppearance = barAppearance

        } else {
            // 更改字體色
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.barTintColor = .black
            // 將被透明效果關閉
            navigationController?.navigationBar.isTranslucent = false
        }


}