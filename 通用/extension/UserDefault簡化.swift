
extension UserDefaults {
    
    public func remove<T>(_ key: DefaultsKey<T>) {
        removeObject(forKey: key.key)
    }
    
    public subscript(key: DefaultsKey<Bool>) -> Bool {
        get { return bool(forKey: key.key) }
        set { set(newValue, forKey: key.key) }
    }
    
    public subscript(key: DefaultsKey<String>) -> String {
        get { return string(forKey: key.key) ?? "" }
        set { set(newValue, forKey: key.key) }
    }
    
    public subscript(key: DefaultsKey<[String]>) -> [String] {
        get { return (array(forKey: key.key) as? [String]) ?? [] }
        set { set(newValue, forKey: key.key) }
    }
    
    public subscript(key: DefaultsKey<Int>) -> Int {
        get { return integer(forKey: key.key) }
        set { set(newValue, forKey: key.key) }
    }
    
    public subscript(key: DefaultsKey<[Int]>) -> [Int] {
        get { return (array(forKey: key.key) as? [Int]) ?? [] }
        set { set(newValue, forKey: key.key) }
    }
    
    public subscript(key: DefaultsKey<UInt>) -> UInt {
        get { return object(forKey: key.key) as? UInt ?? 0 }
        set { set(newValue, forKey: key.key) }
    }
    
    public subscript(key: DefaultsKey<Date>) -> Date {
        get { return object(forKey: key.key) as? Date ?? Date(timeIntervalSince1970: 0) }
        set { set(newValue, forKey: key.key) }
    }
    
    public subscript<T: Codable>(key: DefaultsKey<T>) -> T? {
        get {
            if let data = data(forKey: key.key) {
                return try? JSONDecoder().decode(T.self, from: data)
            }
            return nil
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                set(data, forKey: key.key)
            }
        }
    }
    
    public subscript<T>(key: DefaultsKey<T>) -> T? {
        get {
            if let data = data(forKey: key.key) {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
            }
            return nil
        }
        set {
            if let newValue = newValue {
                set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: key.key)
            }
        }
    }
}




/*自訂義 userDefautsKey*/

public class DefaultsKeys {}

/// UserDefaults的key
public class DefaultsKey<ValueType>: DefaultsKeys {
    
    public let key: String
    
    public init(_ key: String) {
        self.key = key
    }
}

// MARK: - 自定義UserDefaults的key
extension DefaultsKeys {
    
    /// example
    static let apiData = DefaultsKey<String>("apiData")

}