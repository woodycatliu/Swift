//
//  OptionalNotified.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/7/24.
//

import Foundation

@propertyWrapper
public class OptionalNotified<Value: Equatable> {
    /// handler value change: non-optional to optional
    public let optionalNotificationName: Notification.Name
    /// handler value change: non-optional to non-optional
    public let updateNotificationName: Notification.Name
    /// handler value change: optional to non-optional
    public let nonNotificationName: Notification.Name
    
    private let notificationName: NotificaionName
    
    private var _queue: OperationQueue? = nil
    
    public var wrappedValue: Value? {
        didSet {
            switch (oldValue == nil , wrappedValue == nil) {
            case (true, false):
                NotificationCenter.default.post(name: nonNotificationName, object: nil)
            case (false , true):
                NotificationCenter.default.post(name: optionalNotificationName, object: nil)
            case (false, false):
                guard oldValue != wrappedValue else { return }
                NotificationCenter.default.post(name: updateNotificationName, object: nil)
            case (true, true):
                break
            }
        }
    }
    
    public var projectedValue: OptionalNotified<Value> { self }
    
    public init(wrappedValue: Value?, update updateNotificationName: Notification.Name, non nonNotificationName: Notification.Name, optional optionalNotificationName: Notification.Name, queue: OperationQueue? = nil) {
        self.wrappedValue = wrappedValue
        self.updateNotificationName = updateNotificationName
        self.nonNotificationName = nonNotificationName
        self.optionalNotificationName = optionalNotificationName
        
        self._queue = queue
        
        self.notificationName = NotificaionName(non: nonNotificationName, optional: optionalNotificationName, update: updateNotificationName)
    }
    
    public func callAsFunction(option: NotifiedOption, queue: OperationQueue? = nil ,using block: @escaping () -> Void) -> NSObjectProtocol {
        let name: Notification.Name = notificationName.name(option)
        
        let queue: OperationQueue? = queue == nil ? _queue : queue
        
        return NotificationCenter.default.addObserver(forName: name, object: nil, queue: queue) { _ in
            block()
        }
    }
    
    public func callAsFunction(_ observer: Any, option: NotifiedOption, selector: Selector, queue: OperationQueue? = nil) {
        let name: Notification.Name = notificationName.name(option)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    public func removeNotification(_ observer: Any, option: NotifiedOption) {
        let name: Notification.Name = notificationName.name(option)
        NotificationCenter.default.removeObserver(observer, name: name, object: nil)
    }
}


extension OptionalNotified {
    
    public enum NotifiedOption {
        
        case nonOptional
        
        case optional
        
        case update
        
    }
    
    public struct NotificaionName {
        let non: Notification.Name
        
        let optional: Notification.Name
        
        let update: Notification.Name
        
        func name(_ option: NotifiedOption)-> Notification.Name {
            switch option {
            case .nonOptional:
                return non
            case .optional:
                return optional
            case .update:
                return update
            }
        }
    }
    
}
