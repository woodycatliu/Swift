//  Created by Woody Liu on 2022/1/11.
//

import Foundation
import Combine


extension Publisher {
    
    /// with failure
    func assignWeakFunction<T: AnyObject>(failure failureAction: @escaping ((T)->(Failure)->()), success successAction: @escaping ((T)->(Output)->()), target: T)-> AnyCancellable {
        let failFuc: WeakFunction<T, Failure> = .init(target: target, method: failureAction)
        let weakFunction: WeakFunction<T, Output> = .init(target: target, method: successAction)
        
        return sink(receiveCompletion: { [failFuc] in
            if case let .failure(error) = $0 { failFuc.action(error) }
        } , receiveValue: { [weakFunction] in
            weakFunction.action($0)
        })
    }
    
    /// action: when publisher is success
    func assignWeakFunc<T: AnyObject>(_ action: @escaping ((T)->(Output)->()), target: T)-> AnyCancellable {
        
        let weakFunction: WeakFunction<T, Output> = .init(target: target, method: action)

        return sink(receiveCompletion: { _ in } , receiveValue: {
            [weakFunction] in
            weakFunction.action($0)
        })

    }

    /// important: will retain cycle
    func assignFunc(_ action: @escaping ((Output)->()))-> AnyCancellable {
        
        sink(receiveCompletion: { _ in } , receiveValue: {
            action($0)
        })
    }
    
    
}

public struct WeakFunction<Reference: AnyObject, Output> {
    public typealias Method = (Reference) -> (Output) -> Void
    public weak var target: Reference?
    public let method: Method
    public func action(_ output: Output) {
        guard let target = target else {
            return
        }
        method(target)(output)
    }
}
