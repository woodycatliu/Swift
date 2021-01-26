
/*
方便的Date String 轉換類別
可組合出各種需求
*/



import Foundation

class DateUtility {
    
    /// Apple 文件說 DateFormatter init 很貴,使用 static 存起來
    static let dateFormatter = DateFormatter()
    
    var locale: Locale {
        return Locale(identifier: "zh-hant")
    }
    
    private let kWeekDays = [
        1: "日",
        2: "一",
        3: "二",
        4: "三",
        5: "四",
        6: "五",
        7: "六"
    ]
    
    var timeZone: TimeZone {
        
        return TimeZone(identifier: "Asia/Taipei") ?? TimeZone.current
    }
    
    func getDate(by component: Calendar.Component, value: Int, to date: Date = Date()) -> Date? {
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        return calendar.date(byAdding: component, value: value, to: date)
    }
    
    /// 輸入 年 月 日, 如果是合法日期, return Date, 不然 return nil
    /// - Parameters:
    ///   - year: 年: Int
    ///   - month: 月: Int
    ///   - day: 日: Int
    func getDateFrom(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        var compoenents = DateComponents()
        compoenents.calendar = calendar
        compoenents.year = year
        compoenents.month = month
        compoenents.day = day
        compoenents.hour = hour
        compoenents.minute = minute
        compoenents.second = second
        
        if compoenents.isValidDate == false {
            return nil
        }
        return compoenents.date
    }
    
    /// return dateComponents,預設值為 年 月 日 時 分 秒, 可以改
    /// - Parameters:
    ///   - date: 目標 Date
    ///   - dateComponents: 預設值為 年 月 日 時 分 秒, 可以改
    func getDateComponentsFrom(date: Date, dateComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]) -> DateComponents {
           
           var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
           calendar.timeZone = timeZone
           
           return calendar.dateComponents(dateComponents, from: date)
       }
    
    func getMinAndSec(from timeInterval: TimeInterval) -> String {
        
        var timeInt: Int
        
        if timeInterval >= Double(Int.max) || timeInterval <= Double(Int.min) {
            timeInt = 0
        } else if timeInterval < 0 {
            timeInt = 0
        } else {
            timeInt = Int(timeInterval)
        }
        
        let seconds = timeInt % 60
        let minutes = timeInt / 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }

    /// 拿取 weekday String
    /// - Parameter date: 目標 date
    func getWeekDayString(date: Date) -> String {
        
        let components = getDateComponentsFrom(date: date, dateComponents: [.weekday])
        
        if let index = components.weekday,
            let weekday = kWeekDays[index] {
            return weekday
        }
        return ""
    }
    
    func getString(from date: Date, format: String = "yyyy-MM-dd") -> String {
        
        let dateFormatter = DateUtility.dateFormatter
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func getDateFromString(string: String, format: String = "yyyy-MM-dd") -> Date? {
        
        let dateFormatter = DateUtility.dateFormatter
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        if let date = dateFormatter.date(from: string) {
            return date
        }
        
        return nil
    }
    
    func getDateFromTaiwan(string: String) -> Date?{
        let dateFormatter = DateUtility.dateFormatter
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.calendar = Calendar(identifier: .republicOfChina)
        //TODO:- 再做一次一次的 formate 抓出
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = locale
        let date = dateFormatter.date(from: string)
        
        return date
    }
    
    func getStringFromTaiwan(date: Date) -> String{
        
        let dateFormatter = DateUtility.dateFormatter
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        let string = dateFormatter.string(from: date)
        
        return string
    }
    
    /// 利用民國年月日拿到民國年月日 Date 出來會是 0109-XX-XX 格式
    /// - Parameter string: 字串(民國年月日)
    func getDateFromTaiwanToTaiwanEra(string: String) -> Date? {
        
        let dateFormatter = DateUtility.dateFormatter
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = locale
        let date = dateFormatter.date(from: string)
        
        return date
    }
    
    /// 利用民國年月日的 Date 拿到 String 10906 格式
    /// - Parameter date: Date 民國年月日格式
    func transToTWYearTerm(date: Date) -> String {
        
        let dateComponents = getDateComponentsFrom(date: date)
        let year = dateComponents.year ?? 0
        let month = dateComponents.month ?? 0
        let yearString = String(year)
        
        switch month {
        case 1, 2:
            return yearString + "02"
        case 3, 4:
            return yearString + "04"
        case 5, 6:
            return yearString + "06"
        case 7, 8:
            return yearString + "08"
        case 9, 10:
            return yearString + "10"
        case 11, 12:
            return yearString + "12"
        default:
            return ""
        }
    }
    
    func getDateByAdding(byAdding component: Calendar.Component, value: Int, to date: Date = Date()) -> Date? {
        
        return Calendar.current.date(byAdding: component, value: value, to: date)
    }
    
    func getDiff(in components: [Calendar.Component], from: Date, to: Date) -> DateComponents {
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let componentsSet = Set(components)
        
        return calendar.dateComponents(componentsSet, from: from, to: to)
        
    }
    
    func getUnixTime(string: String, formate: String = "yyyyMMdd HH:mm:ss") -> Int{
        let dateFormatter = DateUtility.dateFormatter
        dateFormatter.dateFormat = formate
        dateFormatter.calendar = .current
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        
        let date = dateFormatter.date(from: string)
        
        let timeInterval = date?.timeIntervalSince1970 ?? 0
        return Int(timeInterval)
    }
    
    func unixTimeToString(unixTime: TimeInterval, formate: String = "yyyyMMdd HH:mm:ss") -> String{
        let dateFormatter = DateUtility.dateFormatter
        dateFormatter.dateFormat = formate
        dateFormatter.calendar = .current
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        
        let date = Date.init(timeIntervalSince1970: unixTime)
        
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getDisplayLastestTime(time: Int) -> String {
        let currentTime = Int(Date().timeIntervalSince1970)
        let diffTime = currentTime - time
        
        if diffTime >= 172800 {
            // 超過2天
            
            DateUtility.dateFormatter.dateFormat = "MM月dd日"
            return DateUtility.dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
        } else if diffTime > 86400 && diffTime < 172800 {
            // 大於等於1天
            return NSLocalizedString("昨天", comment: "")
        } else if diffTime >= 3600 {
            // 大於等於1小
            return NSLocalizedString("\(diffTime/3600)小時前", comment: "")
        } else if diffTime > 60 {
            // 最少顯示一分鐘
            return NSLocalizedString("\(diffTime/60)分鐘前", comment: "")
        } else if diffTime > 0 {
            return NSLocalizedString("剛剛", comment: "")
        }
        
        return "剛剛"
    }

}
