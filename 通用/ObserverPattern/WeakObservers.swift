
/*
觀察者模式
*/


final class WeakObservers<ProtoclObject> {
    
    private var mapTable: NSMapTable = NSMapTable<NSString, AnyObject>.init(keyOptions: .strongMemory, valueOptions: .weakMemory)
    
    private var lock: NSLock = NSLock()
    
    var observers: [ProtoclObject] {
        return mapTable.keyEnumerator().allObjects.compactMap { $0 as? ProtoclObject }
    }
    
    /// - Parameters:
    ///   - object: 觀察者
    ///   - key: 指向特定 觀察者 辨識符
    func addObserver(_ object: ProtoclObject, key: String) {
        lock.lock()
        mapTable.setObject(object as AnyObject, forKey: NSString(string: key))
        lock.unlock()
    }
    
    func removeObserver(_ key: String) {
        lock.lock()
        mapTable.removeObject(forKey: NSString(string: key))
        lock.unlock()
    }
    
    func removeAllObservers() {
        lock.lock()
        mapTable.removeAllObjects()
        lock.unlock()
    }
    
    subscript(key: String) -> ProtoclObject? {
        get {
            if let object = mapTable.object(forKey: NSString(string: key)) as? ProtoclObject {
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
