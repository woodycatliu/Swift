/*
Array/Dict 型別在swift 中均是操作指標的數據形態，所以屬於 unsafe 的型別。
當有多線程同時操作同一unsafe 物件時，會造成crash.
以下是自建立一安全型別Array。
利用自建一條queue通道，分配 sync(讀取) 與 async(寫入)，使多線程操作Array/ Dict時
，可以避免同時讀寫的不安全Error。

DispatchQueue(label: "mySafeArray", attributes: .concurrent)
async(flags: .barrier) 
特性：
sync 必須等待已經執行的async(flags: .barrier)任務完成後，才會執行。

ArraySafe優點
- 線程安全
- 效能提升
- 降低讀寫時間
*/





class MySafeArray<T> {
    private let queue = DispatchQueue(label: "mySafeArray", attributes: .concurrent)
    private var array = Array<T>()
}

// 讀取
extension MySafeArray {
    var first: T? {
        var result: T?
        queue.sync { result = array.first }
        return result
    }
    
    var last: T? {
        var result: T?
        queue.sync { result = array.last }
        return result
    }
    
    var count: Int {
        var result: Int!
        queue.sync { result = array.count }
        return result
    }
}

// 寫入
extension MySafeArray {
    func append(_ newElement: T) {
        queue.async(flags: .barrier) {
            [weak self] in
            guard let self = self else { return }
            self.array.append(newElement) }
    }
    
    subscript(_ index: Int) -> T {
        get {
            var result: T!
            queue.sync {
                result = array[index]
            }
            return result
        }
        
        set {
            queue.async(flags: .barrier) {
                [weak self] in
                guard let self = self else { return }
                self.array[index] = newValue
            }
            
        }
        
    }
    
}
