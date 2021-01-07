 
    /// 取當前weekly 優惠時間
    /// - Parameters:
    ///   - fromDay: 開始日期， 1 =  星期天 \ 2 = 星期一
    ///   - util: 結束總天數(不包含開始天數)
    /// - Returns: MM / dd - MM / dd
    func getWeeklyRangeForNextWeek(fromDay: Int, until: Int)-> String {
        let daysForMoon: [Int: Int] = [1: 31, 2: 28, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31]
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        
        guard let weekday = dateComponents.weekday, let month = dateComponents.month, let day = dateComponents.day, var year = dateComponents.year else { return "" }
        
        var diffPervious = weekday - fromDay
        
        if diffPervious < 0 {
            diffPervious += 7
        }
        
        var realFromDay = day - diffPervious
        var fromMoon = month
        
        if realFromDay < 0 {
            switch month - 1 {
            case 2:
                realFromDay = 28 + realFromDay + (checkLeapYear(year: year) ? 1 : 0)
            case 0:
                realFromDay = 31 + realFromDay
                year -= 1
            default:
                if let days = daysForMoon[month - 1] {
                    realFromDay = days + realFromDay
                }
            }
            fromMoon -= 1
        }
        
        var realToDay = realFromDay + until
        var toMoon = fromMoon
        
        if let days = daysForMoon[fromMoon] {
            if fromMoon == 2 && realToDay > days + (checkLeapYear(year: year) ? 1 : 0){
                toMoon += 1
                realToDay = realToDay - days + (checkLeapYear(year: year) ? 1 : 0)
            }else if realToDay > days {
                if fromMoon == 12 {
                    toMoon = 1
                    realToDay = realToDay - days
                } else {
                    toMoon += 1
                    realToDay = realToDay - days
                }
            }
        }
        
        var fromMoonString: String = String(fromMoon)
        var fromDayString: String = String(realFromDay)
        
        var toMoonString: String = String(toMoon)
        var toDayString: String = String(realToDay)
        
        if fromMoon < 10 {
            fromMoonString = "0\(fromMoon)"
        }
        
        if realFromDay < 10 {
            fromDayString = "0\(realFromDay)"
        }
        
        if realToDay < 10 {
            toDayString = "0\(realToDay)"
        }
        
        if toMoon < 10 {
            toMoonString = "0\(toMoon)"
        }
        
        
        return fromMoonString + "/" + fromDayString + "-" + toMoonString + "/" + toDayString
    }
    
    
    
    // 檢查當年是否為閏年
    func checkLeapYear(year: Int)-> Bool {
        if year % 100 == 0 && year % 400 == 0 && year % 4 == 0 {
            return true
        } else if year % 4 == 0 && year % 100 != 0 {
            return true
        }
        return false
    }