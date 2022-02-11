//
//  ViewControllerProvider.swift
//  Timer&Operation
//
//  Created by Woody on 2022/2/11.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

public struct ViewControllerProvider: View {
    public let viewController: AnyView
    public var body: some View {
        return viewController
    }
    
    init<Content>(_ viewController: UIViewController, @ViewBuilder content: (ViewControllerRepresentable)-> Content) where Content: View {
        let vr = ViewControllerRepresentable(vc: viewController)
        self.viewController = AnyView(content(vr))
    }
    
    init(_ viewController: UIViewController) {
        let vr = ViewControllerRepresentable(vc: viewController)
        self.viewController = AnyView(vr)
    }
    
    init(_ viewController: UIViewController, size: ViewLayout.Size) {
        let vr = ViewControllerRepresentable(vc: viewController)
        self.viewController = AnyView(vr.frame(width: size.width, height: size.height, alignment: .center))
    }
}


extension ViewControllerProvider {
    public static var empty: ViewControllerProvider {
        return ViewControllerProvider.init(UIViewController())
    }
}

#endif
