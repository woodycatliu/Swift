//  Created by Woody Liu on 2022/1/11.
//

import Foundation
import Combine


extension Publisher {
    
    /// will not retain cycle
    /// failure: fail to do (closure/function)
    /// success: to do (closure/function)
    /// on: function contain
    /// - Returns: AnyCancellable
    ///  example: assign(failure:  A.faulure, success:  A.success, on: A())
    public func assign<T: AnyObject>(failure failureAction: @escaping ((T)->(Failure)->()), success successAction: @escaping ((T)->(Output)->()), on target: T)-> AnyCancellable {
        
        return sink(receiveCompletion: { [weak target] in
            if let target = target,
            case let .failure(error) = $0 { failureAction(target)(error) }
        } , receiveValue: { [weak target] in
            guard let target = target else { return }
            successAction(target)($0)
        })
    }
    
    /// will not retain cycle
    /// action: success to do (closure/function)
    /// on: function contain
    /// - Returns: AnyCancellable
    ///  example: assign(failure:  A.faulure, success:  A.success, on: A())
    public func assign<T: AnyObject>(to action: @escaping ((T)->(Output)->()), on target: T)-> AnyCancellable {
                
        return sink(receiveCompletion: { _ in } , receiveValue: {
            [weak target] in
            guard let target = target else { return }
            action(target)($0)
        })
        
    }

    /// important: maybe make retain cycle
    /// action: success to do (closure/function)
    /// - Returns: AnyCancellable
    public func assign(to action: @escaping ((Output)->()))-> AnyCancellable {
        
        sink(receiveCompletion: { _ in } , receiveValue: {
            action($0)
        })
    }
    
    
}
