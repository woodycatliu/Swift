//
//  UIViewPreviewProvider.swift
//  Timer&Operation
//
//  Created by Woody on 2022/2/10.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension ViewProvider {
    ///  current preview
    static var display: ViewProvider {
        return .default
    }
    
    

    
}


struct UIView_Preview: PreviewProvider {
    static var previews: some View {
        return ViewProvider.display
    }
}

#endif
