
import Foundation

extension Double {
    
    func rounding(position: Int16)-> Double {
        let hundler = NSDecimalNumberHandler(roundingMode: .plain, scale: position, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let nsNumber = NSDecimalNumber(value: self)
        let newNumber = nsNumber.rounding(accordingToBehavior: hundler)
        
        return Double(newNumber.stringValue) ?? Double(Int(self * 10 * Double(position)) / 10 / Int(position))
    }
    
}
