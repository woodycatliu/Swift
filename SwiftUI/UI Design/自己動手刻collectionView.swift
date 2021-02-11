/*
截至今天 2021/02/10 
SwiftUI 沒有相對應 UIKit 的 collectioinView
好在 Apple 有開放 LazyVGrid 與 LazyHGrid 讓我們可以更容易模擬出
CollectionView

需求：
Section Title
原生相簿的小格視圖
*/


import SwiftUI



struct CollectionView: View {
    private let bounds: CGRect = UIScreen.main.bounds   

    @State var sectionDatas: [[DataModel]] = Array(repeating: DataModel(), count: 20) 
    
    var body: some View {
        ScrollView {
            section(sectionDatas: sectionDatas)
        }
    }


    @ViewBuilder
    func section(sectionDatas: [[DotaModel]])-> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(sectionDatas.indices) {
                index in
                Text("Section \(index)")
                     .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 0))
                     .font(.largeTitle)
                row(rowDatas: sectionDatas[index])
            }
        }
    }


    func row(rowDatas: [DotaModel])-> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
            ForEach(rowDatas.indices) {
                index in
                Image(uiImage: rowDatas[index].image)
                    .resizeable()
                    .scaledToFit()
                    .frame(width: bounds.width / 3, height: bounds.width / 3)
                    .onTapGesture {
                        print(index)
                    }
            }
            .background(Color.white.opacity(0.5))
            .border(Color.black)
        }
        .background(Color.secondary.opacity(0.5))
    }





     struct DataModel {
           var image: UIImage
     }

}