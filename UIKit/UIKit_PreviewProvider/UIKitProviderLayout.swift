//
//  UIKitProviderLayout.swift
//  Timer&Operation
//
//  Created by Woody on 2022/2/11.
//

import UIKit

#if canImport(SwiftUI) && DEBUG
class ViewLayout {
    typealias Size = CGSize
}

extension ViewLayout.Size {
    
    typealias Length = CGFloat
    
    static func Square(_ length: Length)-> Self {
        return Self.init(width: length, height: length)
    }
    
    static func Rectangle(width: Length, heightMultiplier m: Length)-> Self {
        return Self.init(width: width, height: width * m)
    }
}

extension ViewLayout.Size.Length {
    
    static var ScreenWidth: Self {
        return UIScreen.main.bounds.width
    }
    
    static var ScreenHeight: Self {
        return UIScreen.main.bounds.height
    }
}

#endif
