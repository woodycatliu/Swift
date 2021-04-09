import Foundation


    /// 四捨五入取小數點輸出字串
    /// - Parameters:
    ///   - value: 數字
    ///   - min: 最少小數點後幾位數
    ///   - max: 最多小數點後幾位數
    /// - Returns: 字串
    private func doNumberFormatter(value: Double, min: Int, max: Int) -> String {
        let nsNumber = NSNumber(value: value)
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        formater.minimumFractionDigits = min
        formater.maximumFractionDigits = max
        guard let string = formatrer.string(from: nsNumber) else { return String(value)
        }
        return string
    }