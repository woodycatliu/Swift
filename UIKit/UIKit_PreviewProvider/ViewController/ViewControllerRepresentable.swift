//
//  ViewControllerRepresentable.swift
//  Timer&Operation
//
//  Created by Woody on 2022/2/11.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@frozen public struct ViewControllerRepresentable: UIViewControllerRepresentable {
    let vc: UIViewController
    public func makeUIViewController(context: Context) -> some UIViewController {
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

#endif
