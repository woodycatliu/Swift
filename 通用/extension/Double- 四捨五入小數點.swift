
import Foundation

extension Double {
    
    func rounding(to position: Int)-> Double {
        var origin = Decimal(self)
        var willRound = Decimal()
        NSDecimalRound(&willRound, &origin, position, .plain)
        return NSDecimalNumber(decimal: willRound).doubleValue
    }
}
