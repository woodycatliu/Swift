
/*
代理模式: 
複數Delegate 使用Swift Dictionary 會造成 memory leak
使用C NSMapTable 作為字典容器可避免 memoty leak (NSMaptable 有弱引用效果)
WeakDictionary 將NSMapTable 包裝起來便於使用，
透過簡單 NSLock 保護讓使用起來更安全
*/

/// 複數協議管理容器，使用NSMapTable 避免 MemoryLeak
/// 在需要使用複數協議通知的類別實例化
/// 呼叫 addDelegate 添加 delegate

final class WeakDictionary<ProtoclClass> {
    
    private var mapTable: NSMapTable = NSMapTable<NSString, AnyObject>.init()
    
    private var lock: NSLock = NSLock()
    
    var delegates: [ProtoclClass] {
        
        var objects: [ProtoclClass] = []
        
        for key in mapTable.keyEnumerator() {
            if let keyString = key as? NSString, let object = mapTable.object(forKey: keyString) as? ProtoclClass {
                objects.append(object)
            }
        }
        return objects
    }
    
    
    
    /// 呼叫以添加新的delegate
    /// - Parameters:
    ///   - delegate: target
    ///   - string: 指向特定 delegate 辨識符
    func addDelegate(delegate: ProtoclClass, string: String) {
        lock.lock()
        mapTable.setObject(delegate as AnyObject, forKey: NSString(string: string))
        lock.unlock()
    }
    
    
    func removeDelegate(string: String) {
        lock.lock()
        mapTable.removeObject(forKey: NSString(string: string))
        lock.unlock()
    }
    
    func removeAllDelegate() {
        lock.lock()
        mapTable.removeAllObjects()
        lock.unlock()
    }
    
    
    subscript(key: String) -> ProtoclClass? {
        get {
            if let object = mapTable.object(forKey: NSString(string: key)) as? ProtoclClass {
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

