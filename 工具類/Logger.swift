/*
方法一： print 出呼叫 file檔名
方法二： 傳入Caller
*/


class Logger {
    
    private init() {
    }
    
    static func log<T>(message: T, file: String = #file, method: String = #function) {
        #if DEBUG
        let time = DateUtility().getString(from: Date())
        let fileName = (file as NSString).lastPathComponent
        NSLog("[\(fileName): \(method)] \(message) - \(time)")
        #endif
    }
    
    static func log<T, U>(message: T, caller: U, method: String = #function) {
        #if DEBUG
        let time = DateUtility().getString(from: Date())
        NSLog("[\(caller).\(method)] \(message) - \(time)")
        #endif
    }
}