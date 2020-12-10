/*
屬性包裝器: 是swift 便利的語法糖。
可以使用在 struct, enum, class，在初始化時提供便利的方式設定預設值。
一般來說跟平時設計 struct / class 物件時差不多，不過其強大的地方是可以
預設泛型做為框架重複使用。
在UIKit 的環境下，我最常使用在設定 UserDefault 或是 字典檔上。
*/

// 用在URL API 作業時，提供JsonCoable功能
@propertyWrapper
struct UserStorage<T: Codable> {
    
    private let key: String
    private let defaultValue: T
    
    
    init(key: String, defalutValue: T) {
        self.key = key
        self.defaultValue = defalutValue
    }
    
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else{
                return defaultValue
            }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}


// 一般使用
@propertyWrapper
struct UserStorage<T: Codable> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let value = UserDefaults.standard.object(forKey: key) as? T else {
                return defaultValue
            }
            return value
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
}

// MARK: 一般使用
class Use {
    
    @UserStorage(key: "shit", defalutValue: true)
    var testShit: Bool
    
    @UserStorages(key: "MoreShit", defaultValue: false)
    var moreShit: Bool

}

 // MARK: enum 

enum Shits {
    @UserStorages(key: "shit", defaultValue: true) static var doShit: Bool
    @UserStorages(key: "moreShit", defaultValue: true) static var moreShit: Bool
}


print(Shits.doShit) // true
Shits.doShit = false 
print(Shits.doShit) // false

