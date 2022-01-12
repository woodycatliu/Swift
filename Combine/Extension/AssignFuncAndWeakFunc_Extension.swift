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
        let failMethod: WeakFunction<T, Failure> = .init(method: failureAction, on: target)
        let weakFunction: WeakFunction<T, Output> = .init(method: successAction, on: target)
        
        return sink(receiveCompletion: { [failMethod] in
            if case let .failure(error) = $0 { failMethod(error) }
        } , receiveValue: { [weakFunction] in
            weakFunction($0)
        })
    }
    
    /// will not retain cycle
    /// action: success to do (closure/function)
    /// on: function contain
    /// - Returns: AnyCancellable
    ///  example: assign(failure:  A.faulure, success:  A.success, on: A())
    public func assign<T: AnyObject>(to action: @escaping ((T)->(Output)->()), on target: T)-> AnyCancellable {
        
        let weakFunction: WeakFunction<T, Output> = .init(method: action, on: target)
        
        return sink(receiveCompletion: { _ in } , receiveValue: {
            [weakFunction] in
            weakFunction($0)
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

public struct WeakFunction<Reference: AnyObject, Output> {
    public typealias Method = (Reference) -> (Output) -> Void
    public weak var target: Reference?
    public let method: Method
    public func callAsFunction(_ output: Output) {
        guard let target = target else {
            return
        }
        method(target)(output)
    }
    
    init(method: @escaping Method, on target: Reference) {
        self.target = target
        self.method = method
    }
}
