//  Created by Woody Liu on 2022/7/7

import Foundation
import Combine

extension Publishers {
    
    private class BagContainer {
        var bag = Set<AnyCancellable>()
    }
    
    public struct Dump<Upstream> : Publisher where Upstream : Publisher {
        
        private var bagContainer = BagContainer()
        
        public typealias Output = Upstream.Output
        
        public typealias Failure = Upstream.Failure
        
        public let upstream: AnyPublisher<Output, Failure>
        
        public let prefix: String
        
        public init<P: Publisher>(_ publisher: P, _ prefix: String = "") where P.Output == Output, P.Failure == Failure {
            self.prefix = prefix
            self.upstream = publisher.eraseToAnyPublisher()
        }
        
        public func receive<S: Combine.Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
            self.upstream.subscribe(subscriber)
            shareBinding(self.upstream.share(), prefix)
        }
        
        private func shareBinding<P: Publisher>(_ share:  Publishers.Share<P>, _ prefix: String) {
            let prefix = prefix.isEmpty ? "" : "\(prefix) "
            share.sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    Swift.print("\(prefix)Finished  -----------------")
                case .failure(let error):
                    Swift.print("\(prefix)Error in  -----------------")
                    Swift.dump(error)
                    Swift.print("\(prefix)Error End -----------------")
                }
            }, receiveValue: { value in
                Swift.print("\(prefix)Value in  -----------------")
                Swift.dump(value)
                Swift.print("\(prefix)Value End -----------------")
            }).store(in: &bagContainer.bag)
        }
    }
}

extension Publisher {
    
    public func dump(_ prefix: String = "") -> Publishers.Dump<Self> {
        return Publishers.Dump(self, prefix)
    }
    
    public func debugDump(_ prefix: String = "")-> AnyPublisher<Self.Output, Self.Failure> {
       #if DEBUG
        return dump(prefix).eraseToAnyPublisher()
       #else
        return AnyPublisher(self)
       #endif
    }
}
