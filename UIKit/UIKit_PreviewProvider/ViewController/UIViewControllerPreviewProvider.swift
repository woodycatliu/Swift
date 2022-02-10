//
//  UIViewControllerPreviewProvider.swift
//  Timer&Operation
//
//  Created by Woody on 2022/2/10.
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
}


extension ViewControllerProvider {
    public static var empty: ViewControllerProvider {
        return ViewControllerProvider.init(UIViewController())
    }
}


@frozen public struct ViewControllerRepresentable: UIViewControllerRepresentable {
    let vc: UIViewController
    public func makeUIViewController(context: Context) -> some UIViewController {
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        return ViewControllerProvider.empty
    }
}

#endif
