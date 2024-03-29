//
//  ViewRepresentable.swift
//
//  Created by Woody on 2022/2/11.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@frozen public struct ViewRepresentable: UIViewRepresentable {
    let view: UIView
    public func makeUIView(context: Context) -> some UIView {
        return view
    }
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}

#endif
