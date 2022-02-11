//
//  UIViewProvider.swift
//  Timer&Operation
//
//  Created by Woody on 2022/2/11.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

public struct ViewProvider: View {
    public let view: AnyView
    public var body: some View {
        return view
    }
    
    init<Content>(_ view: UIView, @ViewBuilder content: (ViewRepresentable)-> Content) where Content: View {
        let vr = ViewRepresentable(view: view)
        self.view = AnyView(content(vr))
    }
    
    init(_ view: UIView) {
        let vr = ViewRepresentable(view: view)
        self.view = AnyView(vr)
    }
    
    init(_ view: UIView, size: ViewLayout.Size) {
        let vr = ViewRepresentable(view: view)
        self.view = AnyView(vr.frame(width: size.width, height: size.height, alignment: .center))
    }
    /// sample
    public static let `default`: ViewProvider = .init(UIView(), content: { $0.overlay(Color.red)})
    
}



#endif
