//
//  UIViewControllerPreviewProvider.swift
//  Timer&Operation
//
//  Created by Woody on 2022/2/10.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension ViewControllerProvider {
    static var display: ViewControllerProvider {
        return .empty
    }
}


struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        return ViewControllerProvider.display
    }
}

#endif
