//  Created by Woody Liu on 2022/1/3.

import Combine

extension Publisher where Failure == Never {
    
    /// you can change funcation name to assign
    func assignUNRetain<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root)-> AnyCancellable {
        sink(receiveValue: { [weak root] in
            root?[keyPath: keyPath] = $0
        })
    }
    
}
