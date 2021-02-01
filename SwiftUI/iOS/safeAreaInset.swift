extension CGFloat {
    static func safeAreaInset(type: SafeAreaType)-> CGFloat {
        var safeInset: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        if let window = UIApplication.shared.windows.first, window.isKeyWindow {
            let inset = window.safeAreaInsets
            safeInset = EdgeInsets(top: inset.top, leading: inset.left, bottom: inset.bottom, trailing: inset.right)
        }
        

        switch type {

        case .top:
            return safeInset.top
        case .leading:
            return safeInset.leading
        case .trailing:
            return safeInset.trailing
        case .bottom:
            return safeInset.bottom
        }
    }
}

enum SafeAreaType {
    case top
    case leading
    case trailing
    case bottom
}
