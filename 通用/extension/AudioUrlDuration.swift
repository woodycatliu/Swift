

import Foundation
import AVFoundation

extension URL {
    
    // 專門儲存 duration Cache
    class DurationCache {
        static let shard: DurationCache = DurationCache()
        private init() {}
        
        private var cache: [String: Double] = [:]
        
        private let lock: NSLock = NSLock()
        
        func getDuration(urlString: String)-> Double? {
            return cache[urlString]
        }
        //
        func append(urlString: String, duration: Double) {
            lock.lock()
            defer {
                lock.unlock()
            }
            cache[urlString] = duration
        }
    }
    
    func mediaDuration(completion: @escaping (Double, URL)-> Void) {
        let cache = DurationCache.shard
        
        if let duration = cache.getDuration(urlString: self.absoluteString) {
            completion(duration, self)
            return
        }
        
        // 依照Apple 文件說明
        // asset.duration 會實際call 網路層去取值
        // 使用 loadValuesAsynchronously 異步處理
        // 為了避免 UI 等待時間過長，透過 DurationCache 單例管理
        let asset = AVURLAsset(url: self, options: nil)
        asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            var error: NSError? = nil
            switch asset.statusOfValue(forKey: "duration", error: &error) {
            case .loaded:
                let audioDuration = asset.duration
                let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
                completion(Double(audioDurationSeconds), self)
                cache.append(urlString: self.absoluteString, duration: Double(audioDurationSeconds))
            default:
                completion(0, self)
            }
        }
    }
}
