/*
compressImgMid: 二分壓縮法，指定預期的 MB 

imgWithNewSize: 更改 img 尺寸，可依照預期 imgView 的尺寸去縮放（一般縮到跟 imgView 預期最大即可)
*/



extension UIImage {
    
    /// 壓縮img 至指定大小
    /// - Parameter MB: 預設1
    /// - Returns: 已壓縮 Data
    public func compressImgMid(MB: Int = 1)-> Data? {
        let maxLength = MB * 1024 * 1024
        var compression: CGFloat = 1
        
        guard var data = self.jpegData(compressionQuality: compression) else {
            Logger.log(message: "壓縮失敗")
            return nil
        }
        Logger.log(message: "原始kb: \(Double(data.count / 1024)) kb")
        if data.count < maxLength { return data }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        
        for i in 0..<6 {
            compression = (max + min) / 2
            
            guard let newData = self.jpegData(compressionQuality: compression) else {
                Logger.log(message: "第\(i)次壓縮失敗")
                return data
            }
            
            Logger.log(message: "第\(i)次壓縮: \(Double(newData.count / 1024)) kb")
            data = newData
            
            if CGFloat(newData.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        
        return data
    }
    
    /// 圖片尺寸
    /// - Parameter size: 預設為螢幕 1/3
    /// - Returns: UIImage?
    public func imgWithNewSize(size: CGSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3))-> UIImage? {
        
        var newSize = size
        
        if self.size.height > size.height {
            newSize.width = size.height / self.size.height * self.size.width
        }
        
        UIGraphicsBeginImageContext(newSize)
        
        self.draw(in: CGRect(origin: .zero, size: newSize))
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImg
        
    }
    
}
