//
//  Date+Extension.swift
//  Datculator
//
//  Created by Evgeny Turchaninov on 20.03.2020.
//  Copyright © 2020 Evgeny Turchaninov. All rights reserved.
//

import Foundation

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        //  dateFormatter.locale = Locale(identifier: "ru")
        //        let sysLocale = NSLocale.current
        //   print("locale: \(sysLocale)")
        
        //        dateFormatter.locale = sysLocale
        //      dateFormatter.dateStyle = .medium
        dateFormatter.dateStyle = .short
        //       dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM yy")
        
        return dateFormatter.string(from: self)
    }
    var toShortString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EE dd MMMM yyyy")
//        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM")
        return dateFormatter.string(from: self)
    }
    
    
    var toWeekDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EE")
        return dateFormatter.string(from: self)
    }

    var timeString: String {
        let dateFormatter = DateFormatter()
        //        dateFormatter.setLocalizedDateFormatFromTemplate("EE dd MMMM yy")
        dateFormatter.timeStyle = .short
  //      dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return dateFormatter.string(from: self)
    }

    var interval: Double {
//        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
//        let cleanDate = Calendar.current.date(from: components)
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let interval = self.timeIntervalSince(startDate) / 24 / 3600
//        let value = cleanDate?.timeIntervalSince(startDate) ?? 0.0
        return interval.rounded()
    }
    
    private func zeroHoursDate (date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        // fromDate - дата, от которой считаем дни, с 0:00:00,000
        return Calendar.current.date(from: components)!
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        let fromDate = zeroHoursDate(date: date)
        let toDate = zeroHoursDate(date: self)
        return Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day ?? 0
    }
    
    var justDate: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
    
    var yearInt: Int {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year ?? 0
    }
    var monthInt: Int {
        let components = Calendar.current.dateComponents([.month], from: self)
        return components.month ?? 0
    }
    var dayInt: Int {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day ?? 0
    }

    var isToday: Bool {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return Calendar.current.date(from: components)! == Calendar.current.date(from: todayComponents)!
    }
    var firstOfThisMonth: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.day = 1
        // fromDate - дата, у которой 1 число текущего месяца
        return Calendar.current.date(from: components)!
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var yearMonths: Int {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        if let years = components.year {
            if let months = components.month {
                return 12 * years + months
            }
        }
        return 0
    }
    
    var dayFromDate: Int {
        return Calendar.current.component(.day, from: self)
    }

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func addToDate(days: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        let interval = TimeInterval(days * 60 * 60 * 24)
        return Calendar.current.date(from: components)! + interval
    }
}
