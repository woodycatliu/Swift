//
//  ViewRepresentable.swift
//  Timer&Operation
//
//  Created by Woody on 2022/2/11.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension ViewProvider {
    // Sample
    
    
    
}

@frozen public struct ViewRepresentable: UIViewRepresentable {
    let view: UIView
    public func makeUIView(context: Context) -> some UIView {
        return view
    }
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}

#endif
