import UIKit

/*
 關閉UIView Anitmate小技巧。
 有時候設定一系列 View 互動動畫， 突然遇到一個需求，需要關閉特定動畫，但是其他動畫要繼續執行的需求時，
 就會特別頭痛。
 比如內建 TableView delete/  insert 動畫 + 自定義的其他動畫時，處理起來會特別煩瑣。
 而我們可以用簡單的 UIView.performWithoutAnimation 配上 main Therad 處理這件事情
 */

UIView.performWithoutAnimation {
    // 動畫被取消，但是自動判斷Difference 不會失效
    yourTableViewDiffableDataSource().apply(yourSnapshot, animatingDifferences: true)
    
    // 動畫不會被取消
    yourAnimationOne()
    
    // 動畫被取消
    yourAnimationTwo()
    
    // 動畫被取消
    yourAnimationThree()
}


// 包在DispatchQueue.main 內將不會被取消動畫
func yourAnimationOne() {
    DispatchQueue.main.async {
        // do amitmate
        // 動畫區塊
    }
}

// 不包在DispatchQueue.main 內
func yourAnimationTwo() { ... do anitmate}
func yourAnimationThree() { ... do anitmate}