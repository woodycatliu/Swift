/*
在取消動畫1有提到如何關閉 DiffableDataSource動畫方式，在這邊來聊聊這樣做的用意，並且提供第二種方法。

我這邊先假設你已經使用過 UITableViewDiffableDataSource，並且大致了解他的API 用法。
在使用 DiffableDataSource 時，在對cell賦值或是更新值時都會call apply(yourSnapshot, animatingDifferences: true)
animatingDifferences 關閉時除了關閉動畫以外，其實也失去 UITableViewDiffableDataSource 自動篩選新值與舊值的功能，簡單說
關閉時 dataSource 會對全部cell 都做 insert的方法。
但有時候我們就是需要他自動比對值是否有不同，卻不要他的動畫。

這一篇教的是另一種方式。

原理:  
- 上面有提到，UITableViewDiffableDataSource 在更新值時用的是 tableView.insert 的方法。
- 如果全部數據都不同時，他還會搭配 tableView.moveRow 的方法。

所以今天我們就子類話再搭配覆寫方法來處理
*/


class MyTableView: UITableView {
    

    // 關閉全部值變化動畫
    override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            () -> Void in
            UIView.setAnimationsEnabled(true)
        }
        super.moveRow(at: indexPath, to: newIndexPath)
        CATransaction.commit()
    }

    // 關閉部分值更新動畫
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.insertRows(at: indexPaths, with: .none)
    }
    

}

