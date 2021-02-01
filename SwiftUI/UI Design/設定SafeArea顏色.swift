/*
思緒: 已Zstack 包裝，先在最底層放一塊超過邊界的Color
再依序疊上去
*/


extension Color {
    static func setSafeColor<T: View>(safeAreaColor: UIColor, mainView: T, mainViewBackColor: UIColor?)-> AnyView {
        let newView: some View = ZStack{
            
            Color(safeAreaColor)
                .edgesIgnoringSafeArea(.all)
            if let mainViewBackColor = mainViewBackColor {
                Color(mainViewBackColor)
            }
            mainView
        }
        return AnyView(newView)
    }
}

/*
回傳sateArea 大小的 Color
Bottom要慎用，因為SwiftUI 特性，無法簡單的將Bottom 置底
*/


extension Color {
    
    static func safeArea(type: SafeAreaType, color: UIColor)-> AnyView {
        switch type {
        case .top:
            return  AnyView(GeometryReader {
                geo in
                Color(color)
                    .frame(minHeight: geo.safeAreaInsets.top, maxHeight: geo.safeAreaInsets.top)
                    .ignoresSafeArea()
            })
        case .leading:
            return  AnyView(GeometryReader {
                geo in
                Color(color)
                    .frame(minWidth: geo.safeAreaInsets.leading, maxWidth: geo.safeAreaInsets.leading)
                    .ignoresSafeArea()
            })
        case .trailing:
            return  AnyView(GeometryReader {
                geo in
                Color(color)
                    .frame(minWidth: geo.safeAreaInsets.trailing, maxWidth: geo.safeAreaInsets.trailing)
                    .ignoresSafeArea()
            })
        case .bottom:
            return  AnyView(GeometryReader {
                geo in
                Color(color)
                    .frame(minHeight: geo.safeAreaInsets.bottom, maxHeight: geo.safeAreaInsets.bottom)
            }
            )
        }
    }