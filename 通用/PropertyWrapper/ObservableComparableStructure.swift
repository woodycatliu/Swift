//
//  ObservableComparableStructure.swift
//  Created by Woody on 2022/8/24.
//

import Foundation


@propertyWrapper
public class ObservableComparableStructure<T: Comparable> {
    
    public class ClosureEntity: ObservableCancellable {
        
        let queue: DispatchQueue?
        var closure: Closure?
        init(_ identifier: String, queue: DispatchQueue?, closure: @escaping Closure) {
            self.queue = queue
            self.closure = closure
            super.init(identifier)
        }
        
        public override func cancel() {
            closure = nil
        }
       
    }
    
    typealias Closure = ((T) -> Void)
    
    typealias Pool = WeakDictionaryRoot<ClosureEntity>
    
    private var _value: T {
        didSet {
            guard oldValue != _value else { return }
            execute()
        }
    }
    
    private var _closures: Pool = Pool() {
        didSet {
            execute()
        }
    }
        
    public var wrappedValue: T {
        get {
            _value
        }
        set {
            _value = newValue
        }
    }
    
    public var projectedValue: ObservableStructure<T> {
        self
    }
    
    public init(wrappedValue: T) {
        self._value = wrappedValue
    }
    
    /// 觀察 value
    /// - Parameters:
    ///   - identifier: 辨識符，make hasable
    ///   - queue: block 執行時所在的線程
    ///   - block: 值變化後要執行的動作
    /// - Returns: ObservableCancellable 可取消觀察的物件，必須用強引用抓住。
    public func observe(_ identifier: String, queue: DispatchQueue? = nil, using block: @escaping (T) -> Void)-> ObservableCancellable {
        let closures = _closures
        let entity = ClosureEntity.init(identifier, queue: queue, closure: block)
        closures.addValue(entity, string: identifier)
        _closures = closures
        return entity
    }
    
    /**
     callAsFunction 為 Swift 5.0 新的語法糖
     請參考 [AppCoda](https://www.appcoda.com.tw/swift-5-2/)
     */
    public func callAsFunction(identifier: String, on: DispatchQueue? = nil ,using block: @escaping (T) -> Void)-> ObservableCancellable {
        return observe(identifier, using: block)
    }
    
    public func cancelAllObserveds() {
        _closures.removeAll()
    }
    
    public func cancel(_ identifier: String) {
        _closures.removeValue(identifier)
    }
    
    /// 觀察者數量
    public func count()-> Int {
        return _closures.weakValues.count
    }
    
    private func execute() {
        let value = _value
        let clouses = _closures
        
        clouses.weakValues.forEach { entity in
            if let queue = entity.queue {
                queue.async {
                    entity.closure?(value)
                }
            }
            else {
                entity.closure?(value)
            }
        }
        
    }
}

extension ObservableComparableStructure {
    final class WeakDictionaryRoot<T> {
            
        private var mapTable: NSMapTable = NSMapTable<NSString, AnyObject>.init(keyOptions: .strongMemory, valueOptions: .weakMemory)

        
        private var lock: NSLock = NSLock()
        
        var weakValues: [T] {
            
            var objects: [T] = []
            
            for key in mapTable.keyEnumerator() {
                if let keyString = key as? NSString, let object = mapTable.object(forKey: keyString) as? T {
                    objects.append(object)
                }
            }
            return objects
        }
        
        
        /// 呼叫以添加新的delegate
        /// - Parameters:
        ///   - delegate: target
        ///   - string: 指向特定 delegate 辨識符
        func addValue(_ value: T, string: String) {
            lock.lock()
            mapTable.setObject(value as AnyObject, forKey: NSString(string: string))
            lock.unlock()
        }
        
        
        func removeValue(_ key: String) {
            lock.lock()
            mapTable.removeObject(forKey: NSString(string: key))
            lock.unlock()
        }
        
        func removeAll() {
            lock.lock()
            mapTable.removeAllObjects()
            lock.unlock()
        }
        
        
        subscript(key: String) -> T? {
            get {
                if let object = mapTable.object(forKey: NSString(string: key)) as? T {
                    return object
                } else {
                    return nil
                }
            }
            
            set {
                lock.lock()
                mapTable.setObject(newValue as AnyObject, forKey: NSString(string: key))
                lock.unlock()
            }
            
        }
        
    }

}

