import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last ?? ""
    }
    
    func substring(_ from: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: from)])
    }
    
    var length: Int {
        return self.count
    }
    
    var isBlank: Bool {
        for character in self where !character.isWhitespace {
            return false
        }
        return true
    }
}



extension String {
    
    func localized(with comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
}
