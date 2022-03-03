import Combine
import Foundation

@propertyWrapper
class DidSetPublished<Value> {
    private var _value: Value
    private let subbject: PassthroughSubject<Value, Never> = .init()
    var wrappedValue: Value {
        set {
            _value = newValue
            subbject.send(_value)
        }
        
        get { return _value }
        
    }
    var projectedValue: PassthroughSubject<Value, Never> {
        return subbject
    }
    
    init(wrappedValue value: Value) {
        _value = value
        wrappedValue = value
    }
}

// Another Soulation
extension Publisher where Failure == Never {
    var didSet: AnyPublisher<Output, Never> {
        return self.receive(on: RunLoop.main).eraseToAnyPublisher()
    }
}
