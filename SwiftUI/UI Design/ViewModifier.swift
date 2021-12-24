/*
ViewModifier 
Swift UI 視圖修改器
簡單說就是宣告View時後面一堆命令，如:  .pading()
*/

struct MyStyleStruct: ViewModifier {
    
    func body(content: Content) -> some View {
        content
        .font(.largeTitle)
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 1)
            )
        .foregroundColor(Color.blue)
    }
}

// 或是添加參數

struct MyStyleTwo: ViewModifier {
    let size: CGSize
    let color: UIColor

    func body(content: Content) -> some View {
        content
        .frame(minWidth: size.width, minHeight: size.height)
        .foregroundColor(Color(color))
    }

}


// 使用

struct TheView: View {
    var body:  some View {
        Text("The View")
        .modifier(MyStyleStruct())
        Text("so cool")
            .modifier(MyStyleTwo(size: CGSize(width: 100, height: 200), color: .red))
    }
}

// 或是
extension View {
    func myStyleStruct()-> some View {
        modifier(MyStyleStruct())
    }

    func myStyleTwo(size: CGSize, color: UIColor)-> some View {
        modifier(MyStyleTwo(size: size, color: color))
    }
    
}