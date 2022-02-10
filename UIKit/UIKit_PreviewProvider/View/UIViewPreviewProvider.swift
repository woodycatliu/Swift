//
//  UIViewPreviewProvider.swift
//  Timer&Operation
//
//  Created by Woody on 2022/2/10.
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
}

extension ViewProvider {
    public static let `default`: ViewProvider = .init(UIView(), content: { $0.overlay(Color.red)})
}


@frozen public struct ViewRepresentable: UIViewRepresentable {
    let view: UIView
    public func makeUIView(context: Context) -> some UIView {
        return view
    }
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}



struct UIView_Preview: PreviewProvider {
    static var previews: some View {
        let provider: ViewProvider = .default
        return provider
    }
}


#endif

//struct ViewControllerRepresentable: UIViewControllerRepresentable {
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let vc = TimingDeviceViewController()
//        vc.view.overrideUserInterfaceStyle = .dark
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//    }
//  }
//struct ViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        ViewControllerRepresentable()
//    }
//}
