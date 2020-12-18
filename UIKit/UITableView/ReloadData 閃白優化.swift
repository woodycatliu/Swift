/*
當TableView reload 過於平凡時，會造成閃白或是畫面停頓影響，使用者體驗不好。
尤其是cell 的值需要當下透過 URLSession API 更新時。

解決方法有幾種，以下是我常用也比較熟悉的兩種

1、 API更新值直接在cell裡面用 main Thread做，簡單說是透過 View Model 直接將值傳給 cell 去更新，而不是透過 reloadData 更新
2、 第二種方法是自己搭配取消動畫2的方法寫一個新的reload func。
*/


extension UITableView {
     func myReloadData() {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            () -> Void in
            UIView.setAnimationsEnabled(true)
        } 
        reloadData()
        beginUpdates()
        endUpdates()
        CATransaction.commit()
    }
}